-- LabBooking-SSM - 数据库初始化脚本（修复字符编码版本）
-- 使用方法：mysql -uroot -p123456 --default-character-set=utf8mb4 < db/init_database.sql

-- 删除旧数据库（如果存在）
DROP DATABASE IF EXISTS labbooking;

-- 创建数据库，明确指定 UTF-8 字符集
CREATE DATABASE labbooking DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE labbooking;

-- 1. 用户与权限
CREATE TABLE sys_user (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(64) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL,
  real_name VARCHAR(64),
  email VARCHAR(100),
  phone VARCHAR(30),
  department VARCHAR(100),
  status TINYINT DEFAULT 1,
  create_time DATETIME,
  update_time DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sys_role (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  role_code VARCHAR(64) NOT NULL UNIQUE,
  role_name VARCHAR(64) NOT NULL,
  description VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sys_user_role (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  CONSTRAINT fk_user_role_user FOREIGN KEY (user_id) REFERENCES sys_user(id),
  CONSTRAINT fk_user_role_role FOREIGN KEY (role_id) REFERENCES sys_role(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. 实验室与设备
CREATE TABLE lab_info (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  lab_name VARCHAR(128) NOT NULL,
  location VARCHAR(255),
  manager_id BIGINT,
  description TEXT,
  status VARCHAR(32) DEFAULT 'NORMAL',
  CONSTRAINT fk_lab_manager FOREIGN KEY (manager_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE lab_equipment (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  equipment_name VARCHAR(255) NOT NULL,
  equipment_code VARCHAR(64) NOT NULL UNIQUE,
  model VARCHAR(128),
  lab_id BIGINT,
  type VARCHAR(64),
  status VARCHAR(32) DEFAULT 'AVAILABLE',
  image_path VARCHAR(255),
  usage_notice TEXT,
  create_time DATETIME,
  update_time DATETIME,
  CONSTRAINT fk_equipment_lab FOREIGN KEY (lab_id) REFERENCES lab_info(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. 预约
CREATE TABLE lab_booking (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  equipment_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  purpose VARCHAR(255),
  status VARCHAR(32) DEFAULT 'PENDING',
  apply_time DATETIME,
  approve_time DATETIME,
  approver_id BIGINT,
  approve_comment VARCHAR(255),
  reject_reason VARCHAR(500),
  cancel_time DATETIME,
  create_time DATETIME,
  update_time DATETIME,
  CONSTRAINT fk_booking_equipment FOREIGN KEY (equipment_id) REFERENCES lab_equipment(id),
  CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES sys_user(id),
  CONSTRAINT fk_booking_approver FOREIGN KEY (approver_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. 使用记录
CREATE TABLE lab_usage_log (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  booking_id BIGINT NOT NULL,
  actual_start_time DATETIME,
  actual_end_time DATETIME,
  remark VARCHAR(500),
  create_time DATETIME,
  update_time DATETIME,
  CONSTRAINT fk_usage_booking FOREIGN KEY (booking_id) REFERENCES lab_booking(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. 维护/报修
CREATE TABLE lab_maintenance (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  equipment_id BIGINT NOT NULL,
  report_user_id BIGINT,
  description VARCHAR(500),
  status VARCHAR(32) DEFAULT 'REPORTED',
  create_time DATETIME,
  complete_time DATETIME,
  handler_id BIGINT,
  result VARCHAR(500),
  update_time DATETIME,
  CONSTRAINT fk_maint_equipment FOREIGN KEY (equipment_id) REFERENCES lab_equipment(id),
  CONSTRAINT fk_maint_reporter FOREIGN KEY (report_user_id) REFERENCES sys_user(id),
  CONSTRAINT fk_maint_handler FOREIGN KEY (handler_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. 系统参数（key-value）
CREATE TABLE sys_param (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  param_key VARCHAR(100) UNIQUE NOT NULL,
  param_value VARCHAR(255) NOT NULL,
  remark VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================
-- 预置角色（原脚本已有）
-- =========================
INSERT INTO sys_role (role_code, role_name, description)
VALUES ('ROLE_USER', '普通用户', '学生/教师'),
       ('ROLE_LAB_ADMIN', '实验室管理员', '审核、设备管理'),
       ('ROLE_SYS_ADMIN', '系统管理员', '系统运维管理');

-- =========================
--  新增：预置管理员账号 admin / 123456（BCrypt）
-- 说明：BCrypt 每次生成密文不同，但只要 matches("123456", 密文)=true 就行。
-- 这里使用你日志中生成并验证用于重置的密文。
-- =========================
INSERT INTO sys_user (username, password, real_name, email, status, create_time, update_time)
VALUES ('admin',
        '$2a$10$EKDAzsh0Cw8mKKbYv0Zy2OLiIlilpcfVTSQiwP6ra3RN3i0nhJHDq',
        '系统管理员',
        'admin@example.com',
        1,
        NOW(),
        NOW());

-- =========================
-- 新增：为 admin 绑定系统管理员角色 ROLE_SYS_ADMIN
-- 不写死 id：通过 username 和 role_code 查出对应 id
-- =========================
INSERT INTO sys_user_role (user_id, role_id)
SELECT u.id, r.id
FROM sys_user u
JOIN sys_role r ON r.role_code = 'ROLE_SYS_ADMIN'
WHERE u.username = 'admin';

-- 示例数据：实验室与设备
INSERT INTO lab_info (lab_name, location, status) VALUES
('电子工程实验室', 'A栋305', 'NORMAL'),
('自动化实验室', 'B栋210', 'NORMAL'),
('计算机实验室', 'C栋101', 'NORMAL'),
('物理实验室', 'D栋202', 'NORMAL'),
('化学实验室', 'D栋301', 'NORMAL');

INSERT INTO lab_equipment (equipment_name, equipment_code, model, lab_id, type, status, usage_notice, create_time, update_time)
VALUES
-- 电子工程实验室设备
('示波器', 'EQ-OSC-001', 'Tektronix TBS 1052B', 1, '示波器', 'AVAILABLE', '使用前请阅读操作手册，注意探头接地', now(), now()),
('直流电源', 'EQ-PSU-001', 'Rigol DP832', 1, '电源', 'AVAILABLE', '输出电压不超过30V，使用时注意极性', now(), now()),
('信号发生器', 'EQ-SIG-001', 'Keysight 33500B', 1, '信号发生器', 'AVAILABLE', '频率范围1μHz~30MHz，幅度最大10Vpp', now(), now()),
('数字万用表', 'EQ-DMM-001', 'Fluke 87V', 1, '万用表', 'AVAILABLE', '测量前选择正确档位，避免过载', now(), now()),
-- 自动化实验室设备
('机械臂', 'EQ-ARM-001', 'UR5e', 2, '机械臂', 'MAINTENANCE', '6自由度协作机械臂，负载5kg', now(), now()),
('PLC控制器', 'EQ-PLC-001', 'Siemens S7-1200', 2, 'PLC', 'AVAILABLE', '编程前务必备份程序，使用TIA Portal V16', now(), now()),
('工业相机', 'EQ-CAM-001', 'Basler acA1920', 2, '相机', 'AVAILABLE', 'USB3.0接口，200万像素，配套SDK已安装', now(), now()),
-- 计算机实验室设备
('高性能工作站', 'EQ-WS-001', 'Dell Precision 5820', 3, '工作站', 'AVAILABLE', 'Intel Xeon, 64GB RAM, RTX 3080显卡', now(), now()),
('服务器', 'EQ-SRV-001', 'HP ProLiant DL380', 3, '服务器', 'AVAILABLE', '双路处理器，128GB内存，RAID5配置', now(), now()),
('3D打印机', 'EQ-3DP-001', 'Creality CR-10', 3, '3D打印机', 'AVAILABLE', '打印尺寸300x300x400mm，使用PLA/ABS耗材', now(), now()),
-- 物理实验室设备
('激光干涉仪', 'EQ-LAS-001', 'Michelson M100', 4, '光学仪器', 'AVAILABLE', '精密光学仪器，使用时避免震动', now(), now()),
('高速摄像机', 'EQ-HSC-001', 'Phantom v2512', 4, '摄像机', 'AVAILABLE', '最高帧率25000fps，需预约后培训使用', now(), now()),
-- 化学实验室设备
('分析天平', 'EQ-BAL-001', 'Mettler AE240', 5, '天平', 'AVAILABLE', '精度0.01mg，使用前需预热30分钟', now(), now()),
('气相色谱仪', 'EQ-GC-001', 'Agilent 7890B', 5, '色谱仪', 'AVAILABLE', '需经培训后使用，样品制备要求详见SOP', now(), now()),
('高效液相色谱', 'EQ-HPLC-001', 'Waters e2695', 5, '色谱仪', 'DISABLED', '设备升级中，预计下月可用', now(), now());

-- 系统参数
INSERT INTO sys_param (param_key, param_value, remark)
VALUES ('booking.defaultMinutes', '60', '默认预约时长（分钟）'),
       ('booking.maxAdvanceDays', '14', '最大可提前预约天数'),
       ('booking.maxDurationHours', '4', '单次预约最长时长（小时）'),
       ('booking.cancelMinutesBeforeStart', '30', '预约开始前多少分钟内不可取消');

-- 显示创建结果
SELECT '数据库初始化完成！' AS status;
SELECT CONCAT('数据库字符集: ', @@character_set_database) AS charset_info;
SELECT CONCAT('排序规则: ', @@collation_database) AS collation_info;

-- 验收：检查 admin 是否绑定 ROLE_SYS_ADMIN
SELECT u.id, u.username, r.role_code, r.role_name
FROM sys_user u
LEFT JOIN sys_user_role ur ON ur.user_id = u.id
LEFT JOIN sys_role r ON r.id = ur.role_id
WHERE u.username = 'admin';
