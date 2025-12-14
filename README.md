## LabBooking-SSM 高校实验室设备预约与使用管理系统

### 一、项目简介
基于 SSM（Spring + Spring MVC + MyBatis）的 B/S 系统，实现设备信息管理、预约审批、使用记录与维护管理。

### 二、技术栈
- 前端：JSP + JSTL
- 后端：Spring、Spring MVC、MyBatis、HikariCP、PageHelper、BCrypt
- 数据库：MySQL 

### 三、数据库设计

#### 数据库表结构
项目使用MySQL数据库，包含以下表：

1. **用户权限相关**
   - `sys_user` - 用户表
   - `sys_role` - 角色表
   - `sys_user_role` - 用户角色关联表

2. **实验室设备相关**
   - `lab_info` - 实验室信息表
   - `lab_equipment` - 设备信息表

3. **预约管理相关**
   - `lab_booking` - 预约记录表
   - `lab_usage_log` - 使用记录表

4. **维护管理相关**
   - `lab_maintenance` - 设备维护记录表

5. **系统配置**
   - `sys_param` - 系统参数配置表（key-value）

#### 核心表详细说明

**用户表 (sys_user)**
- 用户基本信息（用户名、密码、姓名等）
- 支持多种角色（学生、教师、管理员等）

**设备表 (lab_equipment)**
- 设备基本信息（名称、编码、型号等）
- 设备状态：AVAILABLE（可用）、MAINTAINING（维修中）、DISABLED（停用）、RESERVED（已预约）、IN_USE（使用中）、SCRAPPED（已报废）

**预约表 (lab_booking)**
- 预约状态：PENDING（待审批）、APPROVED（已批准）、REJECTED（已拒绝）、CANCELLED（已取消）、COMPLETED（已完成）
- 支持预约时间段管理

**系统参数表 (sys_param)**
- 存储系统配置参数
- 默认预约时长、最大提前预约天数等

#### 数据库关系
- 用户与角色：多对多关系（通过sys_user_role关联）
- 实验室与设备：一对多关系
- 设备与预约：一对多关系
- 预约与使用记录：一对一关系
- 设备与维护记录：一对多关系

### 四、目录结构（主要）
```
src/main/java/com/labbooking/ssm/...        # 业务代码（domain/mapper/service/controller/web/exception）
src/main/resources/spring/                  # Spring & Spring MVC 配置
src/main/resources/mybatis/mapper/          # MyBatis XML 映射
src/main/webapp/WEB-INF/jsp/                # JSP 视图
db/                                         # 数据库SQL文件
pom.xml                                     # Maven 配置
```

### 五、快速开始

在项目根目录运行以下 PowerShell 脚本：
```powershell
# 停止Tomcat服务
apache-tomcat-9.0.113\bin\shutdown.bat

# 清理Tomcat工作目录
Remove-Item -Recurse -Force D:\apache-tomcat-9.0.113\work
Remove-Item -Recurse -Force D:\apache-tomcat-9.0.113\temp
Remove-Item -Recurse -Force D:\apache-tomcat-9.0.113\webapps\labbooking*

# 构建项目
mvn clean package -DskipTests

# 部署到Tomcat
Copy-Item target\labbooking-ssm.war D:\apache-tomcat-9.0.113\webapps\

# 启动Tomcat服务
D:\apache-tomcat-9.0.113\bin\startup.bat
```
**注意：** 请根据Tomcat实际安装路径修改脚本中的路径。

导入：
 `db/init_database.sql` - 创建数据库结构和基础数据

### 六、默认账号
- 管理员：admin / 123456
- 普通用户：可通过注册功能自行注册账号



