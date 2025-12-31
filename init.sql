/*
 JeecgBoot 数据库初始化脚本

 Database     : jeecg-boot
 MySQL Version: 8.0+
 Encoding     : UTF-8 (utf8mb4)

 说明：此脚本用于一键部署时初始化数据库，包含完整的表结构和基础数据
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for flyway_schema_history
-- ----------------------------
DROP TABLE IF EXISTS `flyway_schema_history`;
CREATE TABLE `flyway_schema_history` (
  `installed_rank` int NOT NULL COMMENT '安装顺序',
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '版本号',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `script` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '脚本名称',
  `checksum` int DEFAULT NULL COMMENT '校验和',
  `installed_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '安装人',
  `installed_on` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '安装时间',
  `execution_time` int DEFAULT NULL COMMENT '执行耗时（毫秒）',
  `success` tinyint(1) DEFAULT NULL COMMENT '是否成功',
  PRIMARY KEY (`installed_rank`) USING BTREE,
  KEY `flyway_schema_history_s_idx` (`success`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Flyway数据库版本管理历史表';

-- ----------------------------
-- Records of flyway_schema_history
-- ----------------------------
BEGIN;
INSERT INTO `flyway_schema_history` (`installed_rank`, `version`, `description`, `type`, `script`, `checksum`, `installed_by`, `installed_on`, `execution_time`, `success`) VALUES (1, '0', '<< Flyway Baseline >>', 'BASELINE', '<< Flyway Baseline >>', NULL, 'root', '2025-01-01 00:00:00', 0, 1);
COMMIT;

-- ----------------------------
-- Table structure for learning_agent_info
-- ----------------------------
DROP TABLE IF EXISTS `learning_agent_info`;
CREATE TABLE `learning_agent_info` (
  `id` bigint NOT NULL COMMENT '主键ID（雪花ID）',
  `invite_code` varchar(16) COLLATE utf8mb4_general_ci NOT NULL COMMENT '邀请码（唯一，8位）',
  `rebate_rate` decimal(5,4) NOT NULL DEFAULT '0.0500' COMMENT '返利比例（如0.05表示5%）',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1-正常，0-禁用',
  `bind_time` datetime DEFAULT NULL COMMENT '绑定上级时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `del_flag` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-正常，1-删除',
  `user_id` int unsigned NOT NULL COMMENT '用户业务ID',
  `tenant_id` int DEFAULT NULL COMMENT '租户ID',
  `parent_user_id` int unsigned DEFAULT NULL COMMENT '上级用户业务ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_invite_code` (`invite_code`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_parent_user_id` (`parent_user_id`),
  KEY `idx_agent_parent_user` (`parent_user_id`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='代理信息表';

-- ----------------------------
-- Records of learning_agent_info
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_agent_rebate_log
-- ----------------------------
DROP TABLE IF EXISTS `learning_agent_rebate_log`;
CREATE TABLE `learning_agent_rebate_log` (
  `id` bigint NOT NULL COMMENT '主键ID（雪花ID）',
  `payment_id` bigint NOT NULL COMMENT '关联充值记录ID',
  `payment_amount` decimal(10,2) NOT NULL COMMENT '充值金额',
  `rebate_rate` decimal(5,4) NOT NULL COMMENT '返利比例（快照）',
  `rebate_amount` decimal(10,2) NOT NULL COMMENT '返利金额',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：1-已到账，0-待处理',
  `remark` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `agent_user_id` int unsigned NOT NULL COMMENT '代理用户业务ID',
  `from_user_id` int unsigned NOT NULL COMMENT '来源用户业务ID',
  PRIMARY KEY (`id`),
  KEY `idx_payment_id` (`payment_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_agent_user_id` (`agent_user_id`),
  KEY `idx_from_user_id` (`from_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='代理返利记录表';

-- ----------------------------
-- Records of learning_agent_rebate_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_category_mapping
-- ----------------------------
DROP TABLE IF EXISTS `learning_category_mapping`;
CREATE TABLE `learning_category_mapping` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `local_category_id` bigint NOT NULL COMMENT '本地分类ID',
  `platform_category_id` bigint NOT NULL COMMENT '上游分类ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_platform_category` (`platform_category_id`) USING BTREE,
  KEY `idx_local_category` (`local_category_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=233 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='分类映射表';

-- ----------------------------
-- Records of learning_category_mapping
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_course
-- ----------------------------
DROP TABLE IF EXISTS `learning_course`;
CREATE TABLE `learning_course` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '课程名称',
  `content` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '课程介绍',
  `fingerprint` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '字段指纹（xxHash64 lower-hex）',
  `price` decimal(10,2) NOT NULL COMMENT '课程价格',
  `secret_price` decimal(10,2) DEFAULT NULL COMMENT 'VIP秘密价',
  `platform_code` varchar(50) NOT NULL COMMENT '平台代码（如 aixuexi, hzw）',
  `platform_id` int DEFAULT NULL COMMENT '上游平台项目编号',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID，关联learning_course_category.id',
  `category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类名称（冗余存储，避免JOIN）',
  `platform_category_id` bigint DEFAULT NULL COMMENT '上游分类ID',
  `external_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '第三方平台课程ID',
  `docking` tinyint(1) DEFAULT '0' COMMENT '是否需要对接（1-是，0-否）',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态: 1-启用 0-禁用',
  `disabled_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '禁用原因：platform_disabled-平台禁用连带，null-正常状态或手动禁用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `del_flag` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标志',
  `staging_id` bigint DEFAULT NULL COMMENT '关联的暂存表ID（用于追溯来源）',
  `import_source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'manual' COMMENT '入库来源：manual-手动创建, auto_sync-自动同步, staging-暂存表审核',
  `name_locked` int DEFAULT '0' COMMENT '商品信息是否锁定（0-未锁定，1-已锁定，锁定后除价格外的所有信息不受上游同步影响）',
  `tenant_id` int DEFAULT '0' COMMENT '租户ID（0=总站）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_platform_external` (`platform_code`,`external_id`),
  KEY `idx_platform` (`platform_code`) USING BTREE,
  KEY `idx_external_id` (`external_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_course_platform_external` (`platform_code`,`external_id`) USING BTREE,
  KEY `idx_course_platform_id` (`platform_id`) USING BTREE,
  KEY `idx_category_id` (`category_id`) USING BTREE,
  KEY `idx_disabled_reason` (`disabled_reason`) USING BTREE,
  KEY `idx_staging_id` (`staging_id`) USING BTREE,
  KEY `idx_import_source` (`import_source`) USING BTREE,
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1986067960740181130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品表';

-- ----------------------------
-- Records of learning_course
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_course_category
-- ----------------------------
DROP TABLE IF EXISTS `learning_course_category`;
CREATE TABLE `learning_course_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `platform_code` varchar(50) NOT NULL COMMENT '平台代码',
  `external_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '外部分类ID（平台返回的分类ID）',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类描述',
  `parent_id` bigint DEFAULT NULL COMMENT '父分类ID（支持多级分类）',
  `sort_order` int DEFAULT '0' COMMENT '排序号',
  `status` int NOT NULL DEFAULT '1' COMMENT '状态：1-启用，0-禁用',
  `disabled_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '禁用原因：platform_disabled-平台禁用连带，null-正常状态或手动禁用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `del_flag` tinyint DEFAULT '0' COMMENT '逻辑删除标志(0-正常,1-已删除)',
  `tenant_id` int DEFAULT '0' COMMENT '租户ID（0=总站）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_platform_external` (`platform_code`,`external_id`,`del_flag`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`) USING BTREE,
  KEY `idx_platform_del_sort` (`platform_code`,`del_flag`,`sort_order`,`id`) USING BTREE,
  KEY `idx_platform_status` (`platform_code`,`status`) USING BTREE,
  KEY `idx_disabled_reason` (`disabled_reason`) USING BTREE,
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=367 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类表';

-- ----------------------------
-- Records of learning_course_category
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_course_favorite
-- ----------------------------
DROP TABLE IF EXISTS `learning_course_favorite`;
CREATE TABLE `learning_course_favorite` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `user_id` int NOT NULL COMMENT '用户ID（业务ID）',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `del_flag` tinyint DEFAULT '0' COMMENT '删除标记（0-正常，1-删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_course` (`user_id`,`course_id`,`del_flag`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='课程收藏表';

-- ----------------------------
-- Records of learning_course_favorite
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_order
-- ----------------------------
DROP TABLE IF EXISTS `learning_order`;
CREATE TABLE `learning_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID（自增主键）',
  `course_id` bigint NOT NULL COMMENT '课程ID',
  `course_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '课程名称',
  `platform_code` varchar(50) NOT NULL COMMENT '平台代码',
  `school` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '学校名称',
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '学习账号',
  `password` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '学习密码',
  `course_id_external` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '第三方课程ID',
  `price` decimal(10,2) NOT NULL COMMENT '订单价格',
  `quantity` int DEFAULT '1' COMMENT '购买数量',
  `dock_status` tinyint(1) DEFAULT '0' COMMENT '对接状态：0-待对接，1-对接成功，2-对接失败，99-未对接',
  `status` tinyint(1) DEFAULT '0' COMMENT '订单状态：0-待处理，1-处理中，2-已完成，3-已取消',
  `yid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '第三方平台订单ID',
  `progress` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单进度',
  `remarks` text COMMENT '备注信息（完整接口返回）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `version` int DEFAULT '0' COMMENT '乐观锁版本号',
  `del_flag` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标志',
  `course_id_order` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '下单的课程ID',
  `course_name_order` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '下单的课程名称',
  `user_id` int unsigned NOT NULL COMMENT '用户业务ID',
  `tenant_id` int DEFAULT NULL COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_course_id` (`course_id`) USING BTREE,
  KEY `idx_platform` (`platform_code`) USING BTREE,
  KEY `idx_dock_status` (`dock_status`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_yid` (`yid`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE,
  KEY `idx_user_id` (`user_id`),
  KEY `idx_order_tenant_id` (`tenant_id`),
  KEY `idx_order_tenant_create_time` (`tenant_id`,`create_time`),
  KEY `idx_order_user_status` (`user_id`,`status`),
  KEY `idx_order_platform_dock` (`platform_code`,`dock_status`),
  KEY `idx_order_create_time` (`create_time`),
  KEY `idx_order_course_id` (`course_id`),
  KEY `idx_order_yid` (`yid`),
  KEY `idx_order_dock_create_time` (`dock_status`,`create_time`),
  KEY `idx_order_status_create_time` (`status`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=347 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';

-- ----------------------------
-- Records of learning_order
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_order_log
-- ----------------------------
DROP TABLE IF EXISTS `learning_order_log`;
CREATE TABLE `learning_order_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '操作用户ID',
  `operation` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型（CREATE-创建,UPDATE-更新,CANCEL-取消,REFUND-退款,STOP-停止,RESET-重置,REFRESH-刷新,DOCK-对接,COMPLETE-完成）',
  `operation_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '操作名称',
  `old_status` tinyint(1) DEFAULT NULL COMMENT '操作前订单状态',
  `new_status` tinyint(1) DEFAULT NULL COMMENT '操作后订单状态',
  `old_dock_status` tinyint(1) DEFAULT NULL COMMENT '操作前对接状态',
  `new_dock_status` tinyint(1) DEFAULT NULL COMMENT '操作后对接状态',
  `old_progress` varchar(255) DEFAULT NULL COMMENT '操作前进度',
  `new_progress` varchar(255) DEFAULT NULL COMMENT '操作后进度',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '日志内容',
  `remark` text COMMENT '备注（完整接口返回）',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '操作IP',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '用户代理',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_order_id` (`order_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_operation` (`operation`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=814 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单操作日志表';

-- ----------------------------
-- Records of learning_order_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_payment
-- ----------------------------
DROP TABLE IF EXISTS `learning_payment`;
CREATE TABLE `learning_payment` (
  `id` bigint NOT NULL COMMENT '主键ID（雪花ID）',
  `merchant_id` bigint NOT NULL COMMENT '商户配置ID',
  `out_trade_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商户订单号（唯一）',
  `trade_no` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '平台订单号',
  `pay_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '支付方式：alipay/wxpay/qqpay等',
  `amount` decimal(10,2) NOT NULL COMMENT '支付金额',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态：0-待支付，1-已支付，2-已关闭，3-支付失败',
  `pay_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '支付链接',
  `qrcode` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '二维码链接',
  `notify_time` datetime DEFAULT NULL COMMENT '回调时间',
  `notify_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '回调原始数据（JSON）',
  `biz_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务类型（如 AGENT_RECHARGE）',
  `biz_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '业务关联ID',
  `client_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '客户端IP',
  `device` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'pc' COMMENT '设备类型：pc/mobile/wechat/alipay',
  `param` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '扩展参数',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `user_id` int unsigned DEFAULT NULL COMMENT '用户业务ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_out_trade_no` (`out_trade_no`) USING BTREE,
  KEY `idx_merchant_id` (`merchant_id`) USING BTREE,
  KEY `idx_trade_no` (`trade_no`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_biz` (`biz_type`,`biz_id`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE,
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支付流水表';

-- ----------------------------
-- Records of learning_payment
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_payment_merchant
-- ----------------------------
DROP TABLE IF EXISTS `learning_payment_merchant`;
CREATE TABLE `learning_payment_merchant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商户名称',
  `api_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '支付平台API地址',
  `pid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商户ID',
  `merchant_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商户密钥（加密存储）',
  `notify_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '异步通知地址',
  `return_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '同步跳转地址',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用：0-禁用，1-启用',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否默认商户：0-否，1-是',
  `supported_types` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '支持的支付方式（JSON数组）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `del_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-正常，1-删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_enabled` (`enabled`) USING BTREE,
  KEY `idx_is_default` (`is_default`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支付商户配置表';

-- ----------------------------
-- Records of learning_payment_merchant
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_platform_category
-- ----------------------------
DROP TABLE IF EXISTS `learning_platform_category`;
CREATE TABLE `learning_platform_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `platform_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '平台代码',
  `external_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '上游分类ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '上游分类名称',
  `parent_external_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '上游父分类ID',
  `extra_data` json DEFAULT NULL COMMENT '扩展数据',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_platform_external` (`platform_code`,`external_id`) USING BTREE,
  KEY `idx_platform` (`platform_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='上游平台分类表';

-- ----------------------------
-- Records of learning_platform_category
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_platform_config
-- ----------------------------
DROP TABLE IF EXISTS `learning_platform_config`;
CREATE TABLE `learning_platform_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `platform_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '平台类型（ydsj/pangu/huotui/jingyu/aishen/tutu）',
  `adapter_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '适配器类型（指向实际适配器，如aixuexi、hzw等）',
  `platform_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '平台名称',
  `api_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'API基础地址',
  `interface_type` tinyint(1) DEFAULT '1' COMMENT '接口类型：1-官方，2-合作方',
  `credentials` text COMMENT '认证凭证（JSON格式）',
  `enabled` tinyint(1) DEFAULT '1' COMMENT '是否启用：0-禁用，1-启用',
  `sort_order` int DEFAULT '0' COMMENT '排序号',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注信息',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `del_flag` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标志（0-正常，1-删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_platform_type` (`platform_type`,`del_flag`) USING BTREE,
  KEY `idx_enabled` (`enabled`) USING BTREE,
  KEY `idx_sort_order` (`sort_order`) USING BTREE,
  KEY `idx_adapter_type` (`adapter_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2000938577133629442 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='平台配置表';

-- ----------------------------
-- Records of learning_platform_config
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_platform_sync_rule
-- ----------------------------
DROP TABLE IF EXISTS `learning_platform_sync_rule`;
CREATE TABLE `learning_platform_sync_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `platform_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '平台类型（关联 learning_platform_config.platform_type）',
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规则名称（便于识别，如"爱学习加价20%"）',
  `sync_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'manual_review' COMMENT '同步模式：auto_insert-自动入库, semi_auto-半自动, manual_review-手动审核',
  `price_rule_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'original' COMMENT '价格规则类型：original-原价, multiply-倍率, fixed_markup-固定加价, formula-公式',
  `price_multiply` decimal(5,2) DEFAULT '1.00' COMMENT '价格倍率（当 price_rule_type=multiply 时使用，如 1.2 表示加价20%）',
  `price_markup` decimal(10,2) DEFAULT '0.00' COMMENT '固定加价金额（当 price_rule_type=fixed_markup 时使用，如 10 表示加10元）',
  `price_formula` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '价格计算公式（当 price_rule_type=formula 时使用，如 "original_price * 1.2 + 5"）',
  `price_min` decimal(10,2) DEFAULT NULL COMMENT '最低价格限制（计算后价格不能低于此值）',
  `price_max` decimal(10,2) DEFAULT NULL COMMENT '最高价格限制（计算后价格不能高于此值）',
  `price_round_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'none' COMMENT '价格取整模式：none-不取整, round-四舍五入, ceil-向上取整, floor-向下取整',
  `default_category_id` bigint DEFAULT NULL COMMENT '默认分类ID（当无法映射时使用）',
  `unmapped_category_strategy` varchar(20) DEFAULT 'auto_create' COMMENT '未映射分类策略: auto_create, use_default, skip',
  `enable_filter` tinyint(1) DEFAULT '0' COMMENT '是否启用过滤规则（1=是，0=否）',
  `filter_conditions` json DEFAULT NULL COMMENT '过滤条件（JSON格式，如价格范围、名称关键词等）',
  `enabled` tinyint(1) DEFAULT '1' COMMENT '规则是否启用（0=禁用，1=启用）',
  `auto_schedule` tinyint NOT NULL DEFAULT '0' COMMENT '是否启用定时同步：0-否，1-是',
  `cron_expression` varchar(50) DEFAULT NULL COMMENT 'Cron表达式（如 0 0 2 * * ?）',
  `last_sync_time` datetime DEFAULT NULL COMMENT '上次同步时间',
  `next_sync_time` datetime DEFAULT NULL COMMENT '下次预计同步时间',
  `last_sync_status` varchar(20) DEFAULT NULL COMMENT '上次同步状态：COMPLETED/FAILED/COMPLETED_WITH_ERRORS',
  `last_sync_message` varchar(255) DEFAULT NULL COMMENT '上次同步结果消息',
  `priority` int DEFAULT '0' COMMENT '优先级（数字越大优先级越高，暂未使用）',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '规则说明',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `del_flag` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标志（0=正常，1=删除）',
  `auto_sync` tinyint(1) DEFAULT '0' COMMENT '是否自动同步入库（1=是，0=否）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_platform_type` (`platform_type`,`del_flag`) USING BTREE,
  KEY `idx_sync_mode` (`sync_mode`) USING BTREE,
  KEY `idx_enabled` (`enabled`) USING BTREE,
  KEY `idx_priority` (`priority`) USING BTREE,
  KEY `idx_auto_schedule` (`auto_schedule`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='平台同步规则配置表';

-- ----------------------------
-- Records of learning_platform_sync_rule
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_ticket
-- ----------------------------
DROP TABLE IF EXISTS `learning_ticket`;
CREATE TABLE `learning_ticket` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID（自增）',
  `order_id` bigint NOT NULL COMMENT '订单ID（关联 learning_order.id）',
  `user_id` int unsigned NOT NULL COMMENT '发起人业务ID（关联 sys_user.business_id）',
  `tenant_id` int DEFAULT NULL COMMENT '租户ID',
  `title` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT '工单标题（自动生成）',
  `ticket_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '工单类型（字典 ticket_type）',
  `content` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '问题内容',
  `answer` text COLLATE utf8mb4_general_ci COMMENT '回复内容',
  `current_handler_id` int unsigned DEFAULT NULL COMMENT '当前处理人业务ID',
  `status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '未提交' COMMENT '工单状态（未提交/待回复/已回复/已完成）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `del_flag` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-正常，1-删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_id` (`order_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_handler_id` (`current_handler_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_ticket_tenant_id` (`tenant_id`),
  KEY `idx_ticket_tenant_status` (`tenant_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单表';

-- ----------------------------
-- Records of learning_ticket
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_ticket_flow
-- ----------------------------
DROP TABLE IF EXISTS `learning_ticket_flow`;
CREATE TABLE `learning_ticket_flow` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID（自增）',
  `ticket_id` bigint NOT NULL COMMENT '工单ID（关联 learning_ticket.id）',
  `from_handler_id` int unsigned DEFAULT NULL COMMENT '流转前处理人业务ID（NULL表示首次提交）',
  `to_handler_id` int unsigned NOT NULL COMMENT '流转后处理人业务ID',
  `action` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型（submit提交/transfer流转/reply回复/close关闭/reopen重开）',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注/回复内容',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `create_by` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作人',
  PRIMARY KEY (`id`),
  KEY `idx_ticket_id` (`ticket_id`),
  KEY `idx_handler` (`from_handler_id`,`to_handler_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单流转记录表';

-- ----------------------------
-- Records of learning_ticket_flow
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_transaction
-- ----------------------------
DROP TABLE IF EXISTS `learning_transaction`;
CREATE TABLE `learning_transaction` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '交易ID',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `amount` decimal(10,2) NOT NULL COMMENT '交易金额',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '交易类型（DEDUCT-扣款，REFUND-退款）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '交易状态（SUCCESS-成功，FAILED-失败）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `user_id` int unsigned NOT NULL COMMENT '用户业务ID',
  `tenant_id` int DEFAULT NULL COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_order_id` (`order_id`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE,
  KEY `idx_user_id` (`user_id`),
  KEY `idx_tenant_id` (`tenant_id`),
  KEY `idx_tenant_create_time` (`tenant_id`,`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2004724102280601603 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='交易记录表';

-- ----------------------------
-- Records of learning_transaction
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for learning_user_profile
-- ----------------------------
DROP TABLE IF EXISTS `learning_user_profile`;
CREATE TABLE `learning_user_profile` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键ID',
  `balance` decimal(10,2) DEFAULT '0.00' COMMENT '账户余额',
  `is_vip` tinyint(1) DEFAULT '0' COMMENT '是否VIP（1-是，0-否）',
  `discount` decimal(3,2) DEFAULT '1.00' COMMENT 'VIP折扣（0.8表示8折）',
  `vip_expire_time` datetime DEFAULT NULL COMMENT 'VIP到期时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '更新人',
  `del_flag` tinyint(1) DEFAULT '0' COMMENT '逻辑删除标志（0-正常，1-删除）',
  `invited_by_code` varchar(16) DEFAULT NULL COMMENT '注册时使用的邀请码',
  `user_id` int unsigned NOT NULL COMMENT '用户业务ID',
  `invited_by_user_id` int unsigned DEFAULT NULL COMMENT '邀请人业务ID',
  `qq` varchar(20) DEFAULT NULL COMMENT 'QQ号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_is_vip` (`is_vip`) USING BTREE,
  KEY `idx_vip_expire` (`vip_expire_time`) USING BTREE,
  KEY `idx_user_id` (`user_id`),
  KEY `idx_invited_by_user_id` (`invited_by_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Learning用户扩展信息表';

-- ----------------------------
-- Records of learning_user_profile
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_announcement
-- ----------------------------
DROP TABLE IF EXISTS `sys_announcement`;
CREATE TABLE `sys_announcement` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `titile` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标题',
  `msg_content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '内容',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `sender` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发布人',
  `priority` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '优先级（L低，M中，H高）',
  `msg_category` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '2' COMMENT '消息类型1:通知公告2:系统消息',
  `msg_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '通告对象类型（USER:指定用户，ALL:全体用户）',
  `send_status` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发布状态（0未发布，1已发布，2已撤销）',
  `send_time` datetime DEFAULT NULL COMMENT '发布时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '撤销时间',
  `del_flag` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '删除状态（0，正常，1已删除）',
  `bus_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务类型(email:邮件 bpm:流程 tenant_invite:租户邀请)',
  `bus_id` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '业务id',
  `open_type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '打开方式(组件：component 路由：url)',
  `open_page` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组件/路由 地址',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `user_ids` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '指定用户',
  `short_user_ids` text COMMENT '指定用户的简短ID列表（逗号分隔，关联sys_user.business_id）',
  `msg_abstract` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '摘要/扩展业务参数',
  `tenant_id` int DEFAULT '0' COMMENT '租户ID',
  `files` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '附件',
  `visits_num` int DEFAULT NULL COMMENT '访问次数',
  `iz_top` int DEFAULT '0' COMMENT '是否置顶（0:否;  1:是）',
  `iz_approval` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否审批（0否 1是）',
  `bpm_status` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '流程状态',
  `msg_classify` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '消息归类',
  `notice_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '通知类型(system:系统消息、file:知识库、flow:流程、plan:日程计划、meeting:会议)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sanno_endtime` (`end_time`) USING BTREE,
  KEY `idx_sanno_start_time` (`start_time`) USING BTREE,
  KEY `idx_sanno_msg_type` (`msg_type`) USING BTREE,
  KEY `idx_sanno_send_status` (`send_status`) USING BTREE,
  KEY `idx_sanno_del_flag` (`del_flag`) USING BTREE,
  KEY `idx_sanno_tenant_id` (`tenant_id`) USING BTREE,
  KEY `idx_sanno_sender` (`sender`) USING BTREE,
  KEY `idx_sanno_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='系统通告表';

-- ----------------------------
-- Records of sys_announcement
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_announcement_send
-- ----------------------------
DROP TABLE IF EXISTS `sys_announcement_send`;
CREATE TABLE `sys_announcement_send` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `annt_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '通告ID',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户id',
  `short_user_id` int DEFAULT NULL COMMENT '用户简短ID（关联sys_user.business_id）',
  `read_flag` int DEFAULT NULL COMMENT '阅读状态（0未读，1已读）',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `star_flag` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '标星状态( 1为标星 空/0没有标星)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sacm_annt_id` (`annt_id`) USING BTREE,
  KEY `idx_sacm_user_id` (`user_id`) USING BTREE,
  KEY `idx_sacm_read_flag` (`read_flag`) USING BTREE,
  KEY `idx_sacm_star_flag` (`star_flag`) USING BTREE,
  KEY `idx_sas_short_user_id` (`short_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户通告阅读标记表';

-- ----------------------------
-- Records of sys_announcement_send
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_category
-- ----------------------------
DROP TABLE IF EXISTS `sys_category`;
CREATE TABLE `sys_category` (
  `id` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `pid` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '父级节点',
  `name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类型名称',
  `code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类型编码',
  `create_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属部门',
  `has_child` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '是否有子节点',
  `tenant_id` int DEFAULT '0' COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `index_scg_code` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='分类字典表';

-- ----------------------------
-- Records of sys_category
-- ----------------------------
BEGIN;
INSERT INTO `sys_category` (`id`, `pid`, `name`, `code`, `create_by`, `create_time`, `update_by`, `update_time`, `sys_org_code`, `has_child`, `tenant_id`) VALUES ('1590548229606047745', '0', '物料树C', 'C02', 'admin', '2022-11-10 11:33:44', NULL, NULL, 'A01', '1', 0);
INSERT INTO `sys_category` (`id`, `pid`, `name`, `code`, `create_by`, `create_time`, `update_by`, `update_time`, `sys_org_code`, `has_child`, `tenant_id`) VALUES ('1590548229652185090', '1590548229606047745', '上衣C', 'C02A01', 'admin', '2022-11-10 11:33:44', NULL, NULL, 'A01', '1', 0);
INSERT INTO `sys_category` (`id`, `pid`, `name`, `code`, `create_by`, `create_time`, `update_by`, `update_time`, `sys_org_code`, `has_child`, `tenant_id`) VALUES ('1590548229668962305', '1590548229606047745', '裤子C', 'C02A02', 'admin', '2022-11-10 11:33:44', NULL, NULL, 'A01', NULL, 0);
INSERT INTO `sys_category` (`id`, `pid`, `name`, `code`, `create_by`, `create_time`, `update_by`, `update_time`, `sys_org_code`, `has_child`, `tenant_id`) VALUES ('1590548229685739522', '1590548229652185090', '秋衣C', 'C02A01A01', 'admin', '2022-11-10 11:33:44', NULL, NULL, 'A01', NULL, 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_check_rule
-- ----------------------------
DROP TABLE IF EXISTS `sys_check_rule`;
CREATE TABLE `sys_check_rule` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键id',
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则名称',
  `rule_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则Code',
  `rule_json` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则JSON',
  `rule_description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则描述',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_scr_rule_code` (`rule_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='编码校验规则表';

-- ----------------------------
-- Records of sys_check_rule
-- ----------------------------
BEGIN;
INSERT INTO `sys_check_rule` (`id`, `rule_name`, `rule_code`, `rule_json`, `rule_description`, `update_by`, `update_time`, `create_by`, `create_time`) VALUES ('1224980593992388610', '通用编码规则', 'common', '[{\"digits\":1,\"pattern\":\"^[a-z|A-Z]$\",\"message\":\"第一位只能是字母\"},{\"digits\":\"*\",\"pattern\":\"^[0-9|a-z|A-Z|_]{0,}$\",\"message\":\"只能填写数字、大小写字母、下划线\"},{\"digits\":\"*\",\"pattern\":\"^.{3,}$\",\"message\":\"最少输入3位数\"},{\"digits\":\"*\",\"pattern\":\"^.{3,12}$\",\"message\":\"最多输入12位数\"}]', '规则：1、首位只能是字母；2、只能填写数字、大小写字母、下划线；3、最少3位数，最多12位数。', 'admin', '2025-09-13 18:54:19', 'admin', '2020-02-05 16:58:27');
INSERT INTO `sys_check_rule` (`id`, `rule_name`, `rule_code`, `rule_json`, `rule_description`, `update_by`, `update_time`, `create_by`, `create_time`) VALUES ('1225001845524004866', '负责的功能测试', 'test', '[{\"digits\":\"*\",\"pattern\":\"^.{3,12}$\",\"message\":\"只能输入3-12位字符\"},{\"digits\":\"3\",\"pattern\":\"^\\\\d{3}$\",\"message\":\"前3位必须是数字\"},{\"digits\":\"*\",\"pattern\":\"^[^pP]*$\",\"message\":\"不能输入P\"},{\"digits\":\"4\",\"pattern\":\"^@{4}$\",\"message\":\"第4-7位必须都为 @\"},{\"digits\":\"2\",\"pattern\":\"^#=$\",\"message\":\"第8-9位必须是 #=\"},{\"digits\":\"1\",\"pattern\":\"^O$\",\"message\":\"第10位必须为大写的O\"},{\"digits\":\"*\",\"pattern\":\"^.*。$\",\"message\":\"必须以。结尾\"}]', '包含长度校验、特殊字符校验等', 'admin', '2020-02-07 11:57:31', 'admin', '2020-02-05 18:22:54');
COMMIT;

-- ----------------------------
-- Table structure for sys_data_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_data_log`;
CREATE TABLE `sys_data_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'id',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人登录名称',
  `create_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人真实名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人登录名称',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `data_table` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '表名',
  `data_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数据ID',
  `data_content` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '数据内容',
  `data_version` int DEFAULT NULL COMMENT '版本号',
  `type` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'json' COMMENT '类型',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sdl_data_table_id` (`data_table`,`data_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='数据日志表';

-- ----------------------------
-- Records of sys_data_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_depart_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_depart_permission`;
CREATE TABLE `sys_depart_permission` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `depart_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '部门id',
  `permission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '权限id',
  `data_rule_ids` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数据规则id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='部门权限表';

-- ----------------------------
-- Records of sys_depart_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_depart_permission` (`id`, `depart_id`, `permission_id`, `data_rule_ids`) VALUES ('1260925131934519297', '6d35e179cd814e3299bd588ea7daed3f', 'f0675b52d89100ee88472b6800754a08', NULL);
INSERT INTO `sys_depart_permission` (`id`, `depart_id`, `permission_id`, `data_rule_ids`) VALUES ('1260925131947102209', '6d35e179cd814e3299bd588ea7daed3f', '2aeddae571695cd6380f6d6d334d6e7d', NULL);
INSERT INTO `sys_depart_permission` (`id`, `depart_id`, `permission_id`, `data_rule_ids`) VALUES ('1260925131955490818', '6d35e179cd814e3299bd588ea7daed3f', '020b06793e4de2eee0007f603000c769', NULL);
INSERT INTO `sys_depart_permission` (`id`, `depart_id`, `permission_id`, `data_rule_ids`) VALUES ('1260925131959685121', '6d35e179cd814e3299bd588ea7daed3f', '1232123780958064642', NULL);
INSERT INTO `sys_depart_permission` (`id`, `depart_id`, `permission_id`, `data_rule_ids`) VALUES ('1694946354772217858', '1582683631414632450', '1588513553652436993', NULL);
INSERT INTO `sys_depart_permission` (`id`, `depart_id`, `permission_id`, `data_rule_ids`) VALUES ('1694946354784800769', '1582683631414632450', '1592114574275211265', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_depart_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_depart_role`;
CREATE TABLE `sys_depart_role` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `depart_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '部门id',
  `role_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '部门角色名称',
  `role_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '部门角色编码',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='部门角色表';

-- ----------------------------
-- Records of sys_depart_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_depart_role` (`id`, `depart_id`, `role_name`, `role_code`, `description`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1260925293226479618', '6d35e179cd814e3299bd588ea7daed3f', 'roless', 'ssss', NULL, 'admin', '2020-05-14 21:29:51', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_depart_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_depart_role_permission`;
CREATE TABLE `sys_depart_role_permission` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `depart_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '部门id',
  `role_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '角色id',
  `permission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '权限id',
  `data_rule_ids` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数据权限ids',
  `operate_date` datetime DEFAULT NULL COMMENT '操作时间',
  `operate_ip` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作ip',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sdrp_role_per_id` (`role_id`,`permission_id`) USING BTREE,
  KEY `idx_sdrp_role_id` (`role_id`) USING BTREE,
  KEY `idx_sdrp_per_id` (`permission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='部门角色权限表';

-- ----------------------------
-- Records of sys_depart_role_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_depart_role_permission` (`id`, `depart_id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1260925328689319938', NULL, '1260925293226479618', '2aeddae571695cd6380f6d6d334d6e7d', NULL, NULL, NULL);
INSERT INTO `sys_depart_role_permission` (`id`, `depart_id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1260925328706097153', NULL, '1260925293226479618', '020b06793e4de2eee0007f603000c769', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `dict_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '字典名称',
  `dict_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '字典编码',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `del_flag` int DEFAULT NULL COMMENT '删除状态',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `type` int(1) unsigned zerofill DEFAULT '0' COMMENT '字典类型0为string,1为number',
  `tenant_id` int DEFAULT '0' COMMENT '租户ID',
  `low_app_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '低代码应用ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_sd_dict_code` (`dict_code`) USING BTREE,
  KEY `uk_sd_tenant_id` (`tenant_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='数据字典表';

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('0b5d19e1fce4b2e6647e6b4a17760c14', '通告类型', 'msg_category', '消息类型1:通知公告2:系统消息', 0, 'admin', '2019-04-22 18:01:35', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1174509082208395266', '职务职级', 'position_rank', '职务表职级字典', 0, 'admin', '2019-09-19 10:22:41', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1174511106530525185', '机构类型', 'org_category', '机构类型 1公司，2部门，3岗位，4子公司', 0, 'admin', '2019-09-19 10:30:43', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1178295274528845826', '表单权限策略', 'form_perms_type', '', 0, 'admin', '2019-09-29 21:07:39', 'admin', '2019-09-29 21:08:26', NULL, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1199517671259906049', '紧急程度', 'urgent_level', '日程计划紧急程度', 0, 'admin', '2019-11-27 10:37:53', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1199518099888414722', '日程计划类型', 'eoa_plan_type', '', 0, 'admin', '2019-11-27 10:39:36', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1199520177767587841', '分类栏目类型', 'eoa_cms_menu_type', '', 0, 'admin', '2019-11-27 10:47:51', 'admin', '2019-11-27 10:49:35', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1199525215290306561', '日程计划状态', 'eoa_plan_status', '', 0, 'admin', '2019-11-27 11:07:52', 'admin', '2019-11-27 11:10:11', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1209733563293962241', '数据库类型', 'database_type', '', 0, 'admin', '2019-12-25 15:12:12', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1232913193820581889', 'Online表单业务分类', 'ol_form_biz_type', '', 0, 'admin', '2020-02-27 14:19:46', 'admin', '2020-02-27 14:20:23', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1242298510024429569', '提醒方式', 'remindMode', '', 0, 'admin', '2020-03-24 11:53:40', 'admin', '2020-03-24 12:03:22', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1280401766745718786', '租户状态', 'tenant_status', '租户状态', 0, 'admin', '2020-07-07 15:22:25', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1356445645198135298', '开关', 'is_open', '', 0, 'admin', '2021-02-02 11:33:38', 'admin', '2021-02-02 15:28:12', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1600042215909134338', '所属行业', 'trade', '行业', 0, 'admin', '2022-12-06 16:19:26', 'admin', '2022-12-06 16:20:50', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1600044537800331266', '公司规模', 'company_size', '公司规模', 0, 'admin', '2022-12-06 16:28:40', 'admin', '2022-12-06 16:30:23', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1606645341269299201', '职级', 'company_rank', '公司职级', 0, 'admin', '2022-12-24 21:37:54', 'admin', '2022-12-24 21:38:25', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1606646440684457986', '公司部门', 'company_department', '公司部门', 0, 'admin', '2022-12-24 21:42:16', 'admin', '2024-03-18 14:21:56', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1693196536609755137', 'ddd', 'ddd', NULL, 1, 'admin', '2023-08-20 17:41:27', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1784843187992084482', '客户终端类型', 'client_type', NULL, 1, 'jeecg', '2024-04-29 15:12:31', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1934846825077878786', '公告分类', 'notice_type', NULL, 0, 'admin', '2025-06-17 13:33:25', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1937393911539384322', '模版分类', 'msgCategory', NULL, 0, 'admin', '2025-06-24 14:14:38', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('1939572486447292418', '首页关联', 'relation_type', NULL, 0, 'admin', '2025-06-30 14:31:31', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('236e8a4baff0db8c62c00dd95632834f', '同步工作流引擎', 'activiti_sync', '同步工作流引擎', 0, 'admin', '2019-05-15 15:27:33', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('2e02df51611a4b9632828ab7e5338f00', '权限策略', 'perms_type', '权限策略', 0, 'admin', '2019-04-26 18:26:55', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('2f0320997ade5dd147c90130f7218c3e', '推送类别', 'msg_type', '', 0, 'admin', '2019-03-17 21:21:32', 'admin', '2019-03-26 19:57:45', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('3486f32803bb953e7155dab3513dc68b', '删除状态', 'del_flag', NULL, 0, 'admin', '2019-01-18 21:46:26', 'admin', '2019-03-30 11:17:11', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('3d9a351be3436fbefb1307d4cfb49bf2', '性别', 'sex', NULL, 0, NULL, '2019-01-04 14:56:32', 'admin', '2019-03-30 11:28:27', 1, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('4274efc2292239b6f000b153f50823ff', '全局权限策略', 'global_perms_type', '全局权限策略', 0, 'admin', '2019-05-10 17:54:05', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('4c03fca6bf1f0299c381213961566349', 'Online图表展示模板', 'online_graph_display_template', 'Online图表展示模板', 0, 'admin', '2019-04-12 17:28:50', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('4c753b5293304e7a445fd2741b46529d', '字典状态', 'dict_item_status', NULL, 0, 'admin', '2020-06-18 23:18:42', 'admin', '2019-03-30 19:33:52', 1, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('4d7fec1a7799a436d26d02325eff295e', '优先级', 'priority', '优先级', 0, 'admin', '2019-03-16 17:03:34', 'admin', '2019-04-16 17:39:23', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('4e4602b3e3686f0911384e188dc7efb4', '条件规则', 'rule_conditions', '', 0, 'admin', '2019-04-01 10:15:03', 'admin', '2019-04-01 10:30:47', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('4f69be5f507accea8d5df5f11346181a', '发送消息类型', 'msgType', NULL, 0, 'admin', '2019-04-11 14:27:09', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('68168534ff5065a152bfab275c2136f8', '有效无效状态', 'valid_status', '有效无效状态', 0, 'admin', '2020-09-26 19:21:14', 'admin', '2019-04-26 19:21:23', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('6b78e3f59faec1a4750acff08030a79b', '用户类型', 'user_type', NULL, 0, NULL, '2019-01-04 14:59:01', 'admin', '2019-03-18 23:28:18', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('72cce0989df68887546746d8f09811aa', 'Online表单类型', 'cgform_table_type', '', 0, 'admin', '2019-01-27 10:13:02', 'admin', '2019-03-30 11:37:36', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('78bda155fe380b1b3f175f1e88c284c6', '流程状态', 'bpm_status', '流程状态', 0, 'admin', '2019-05-09 16:31:52', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('83bfb33147013cc81640d5fd9eda030c', '日志类型', 'log_type', NULL, 0, 'admin', '2019-03-18 23:22:19', NULL, NULL, 1, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('845da5006c97754728bf48b6a10f79cc', '状态', 'status', NULL, 0, 'admin', '2019-03-18 21:45:25', 'admin', '2019-03-18 21:58:25', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('880a895c98afeca9d9ac39f29e67c13e', '操作类型', 'operate_type', '操作类型', 0, 'admin', '2019-07-22 10:54:29', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('8dfe32e2d29ea9430a988b3b558bf233', '发布状态', 'send_status', '发布状态', 0, 'admin', '2019-04-16 17:40:42', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('977df2e4d66011f08076525400e87d0c', '工单类型', 'ticket_type', '订单售后工单的问题类型分类', 0, 'system', '2025-12-11 15:11:19', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('a7adbcd86c37f7dbc9b66945c82ef9e6', '1是0否', 'yn', '', 0, 'admin', '2019-05-22 19:29:29', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('a9d9942bd0eccb6e89de92d130ec4c4a', '消息发送状态', 'msgSendStatus', NULL, 0, 'admin', '2019-04-12 18:18:17', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('ac2f7c0c5c5775fcea7e2387bcb22f01', '菜单类型', 'menu_type', NULL, 0, 'admin', '2020-12-18 23:24:32', 'admin', '2019-04-01 15:27:06', 1, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('ad7c65ba97c20a6805d5dcdf13cdaf36', 'onlineT类型', 'ceshi_online', NULL, 0, 'admin', '2019-03-22 16:31:49', 'admin', '2019-03-22 16:34:16', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('adapter_type_dict_id', '平台适配器类型', 'adapter_type', '平台配置中使用的适配器类型，对应系统内置的适配器实现', 0, 'admin', '2025-11-12 23:46:50', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('bd1b8bc28e65d6feefefb6f3c79f42fd', 'Online图表数据类型', 'online_graph_data_type', 'Online图表数据类型', 0, 'admin', '2019-04-12 17:24:24', 'admin', '2019-04-12 17:24:57', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('c36169beb12de8a71c8683ee7c28a503', '部门状态', 'depart_status', NULL, 0, 'admin', '2019-03-18 21:59:51', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('c5a14c75172783d72cbee6ee7f5df5d1', 'Online图表类型', 'online_graph_type', 'Online图表类型', 0, 'admin', '2019-04-12 17:04:06', NULL, NULL, 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('d6e1152968b02d69ff358c75b48a6ee1', '流程类型', 'bpm_process_type', NULL, 0, 'admin', '2021-02-22 19:26:54', 'admin', '2019-03-30 18:14:44', 0, 0, NULL);
INSERT INTO `sys_dict` (`id`, `dict_name`, `dict_code`, `description`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `type`, `tenant_id`, `low_app_id`) VALUES ('fc6cd58fde2e8481db10d3a1e68ce70c', '用户状态', 'user_status', NULL, 0, 'admin', '2019-03-18 21:57:25', 'admin', '2019-03-18 23:11:58', 1, 0, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_dict_item
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_item`;
CREATE TABLE `sys_dict_item` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `dict_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '字典id',
  `item_text` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '字典项文本',
  `item_value` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '字典项值',
  `item_color` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '字典项颜色',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `sort_order` int DEFAULT NULL COMMENT '排序',
  `status` int DEFAULT NULL COMMENT '状态（1启用 0不启用）',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sditem_role_dict_id` (`dict_id`) USING BTREE,
  KEY `idx_sditem_role_sort_order` (`sort_order`) USING BTREE,
  KEY `idx_sditem_status` (`status`) USING BTREE,
  KEY `idx_sditem_dict_val` (`dict_id`,`item_value`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='数据字典项表';

-- ----------------------------
-- Records of sys_dict_item
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('0072d115e07c875d76c9b022e2179128', '4d7fec1a7799a436d26d02325eff295e', '低', 'L', NULL, '低', 3, 1, 'admin', '2019-04-16 17:04:59', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('05a2e732ce7b00aa52141ecc3e330b4e', '3486f32803bb953e7155dab3513dc68b', '已删除', '1', NULL, NULL, NULL, 1, 'admin', '2025-10-18 21:46:56', 'admin', '2019-03-28 22:23:20');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('096c2e758d823def3855f6376bc736fb', 'bd1b8bc28e65d6feefefb6f3c79f42fd', 'SQL', 'sql', NULL, NULL, 1, 1, 'admin', '2019-04-12 17:26:26', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('0c9532916f5cd722017b46bc4d953e41', '2f0320997ade5dd147c90130f7218c3e', '指定用户', 'USER', NULL, NULL, NULL, 1, 'admin', '2019-03-17 21:22:19', 'admin', '2019-03-17 21:22:28');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('0ca4beba9efc4f9dd54af0911a946d5c', '72cce0989df68887546746d8f09811aa', '附表', '3', NULL, NULL, 3, 1, 'admin', '2019-03-27 10:13:43', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1030a2652608f5eac3b49d70458b8532', '2e02df51611a4b9632828ab7e5338f00', '禁用', '2', NULL, '禁用', 2, 1, 'admin', '2021-03-26 18:27:28', 'admin', '2019-04-26 18:39:11');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1174509082208395266', '1174511106530525185', '岗位', '3', NULL, '岗位', 1, 1, 'admin', '2019-09-19 10:31:16', '', NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1174509601047994369', '1174509082208395266', '员级', '1', NULL, '', 1, 1, 'admin', '2019-09-19 10:24:45', 'admin', '2019-09-23 11:46:39');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1174509667297026049', '1174509082208395266', '助级', '2', NULL, '', 2, 1, 'admin', '2019-09-19 10:25:01', 'admin', '2019-09-23 11:46:47');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1174509713568587777', '1174509082208395266', '中级', '3', NULL, '', 3, 1, 'admin', '2019-09-19 10:25:12', 'admin', '2019-09-23 11:46:56');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1174509788361416705', '1174509082208395266', '副高级', '4', NULL, '', 4, 1, 'admin', '2019-09-19 10:25:30', 'admin', '2019-09-23 11:47:06');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1174509835803189250', '1174509082208395266', '正高级', '5', NULL, '', 5, 1, 'admin', '2019-09-19 10:25:41', 'admin', '2019-09-23 11:47:12');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1174511197735665665', '1174511106530525185', '公司', '1', NULL, '公司', 1, 1, 'admin', '2019-09-19 10:31:05', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1174511244036587521', '1174511106530525185', '部门', '2', NULL, '部门', 1, 1, 'admin', '2019-09-19 10:31:16', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1178295553450061826', '1178295274528845826', '可编辑(未授权禁用)', '2', NULL, '', 2, 1, 'admin', '2019-09-29 21:08:46', 'admin', '2019-09-29 21:09:18');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1178295639554928641', '1178295274528845826', '可见(未授权不可见)', '1', NULL, '', 1, 1, 'admin', '2019-09-29 21:09:06', 'admin', '2019-09-29 21:09:24');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199517884758368257', '1199517671259906049', '一般', '1', NULL, '', 1, 1, 'admin', '2019-11-27 10:38:44', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199517914017832962', '1199517671259906049', '重要', '2', NULL, '', 1, 1, 'admin', '2019-11-27 10:38:51', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199517941339529217', '1199517671259906049', '紧急', '3', NULL, '', 1, 1, 'admin', '2019-11-27 10:38:58', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199518186144276482', '1199518099888414722', '日常记录', '1', NULL, '', 1, 1, 'admin', '2019-11-27 10:39:56', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199518214858481666', '1199518099888414722', '本周工作', '2', NULL, '', 1, 1, 'admin', '2019-11-27 10:40:03', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199518235943247874', '1199518099888414722', '下周计划', '3', NULL, '', 1, 1, 'admin', '2019-11-27 10:40:08', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199520817285701634', '1199520177767587841', '列表', '1', NULL, '', 1, 1, 'admin', '2019-11-27 10:50:24', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199520835035996161', '1199520177767587841', '链接', '2', NULL, '', 1, 1, 'admin', '2019-11-27 10:50:28', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199525468672405505', '1199525215290306561', '未开始', '0', NULL, '', 1, 1, 'admin', '2019-11-27 11:08:52', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199525490575060993', '1199525215290306561', '进行中', '1', NULL, '', 1, 1, 'admin', '2019-11-27 11:08:58', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1199525506429530114', '1199525215290306561', '已完成', '2', NULL, '', 1, 1, 'admin', '2019-11-27 11:09:02', 'admin', '2019-11-27 11:10:02');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1209733775114702850', '1209733563293962241', 'MySQL5.5', '1', NULL, '', 1, 1, 'admin', '2019-12-25 15:13:02', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1209733839933476865', '1209733563293962241', 'Oracle', '2', NULL, '', 3, 1, 'admin', '2019-12-25 15:13:18', 'admin', '2021-07-15 13:44:08');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1209733903020003330', '1209733563293962241', 'SQLServer', '3', NULL, '', 4, 1, 'admin', '2019-12-25 15:13:33', 'admin', '2021-07-15 13:44:11');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1232913493717512194', '1232913193820581889', '流程表单', 'bpm', NULL, '', 2, 1, 'admin', '2020-02-27 14:20:58', 'admin', '2020-02-27 14:22:20');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1232913605382467585', '1232913193820581889', '测试表单', 'temp', NULL, '', 4, 1, 'admin', '2020-02-27 14:21:25', 'admin', '2020-02-27 14:22:16');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1232914232372195330', '1232913193820581889', '导入表单', 'bdfl_include', NULL, '', 5, 1, 'admin', '2020-02-27 14:23:54', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1234371726545010689', '4e4602b3e3686f0911384e188dc7efb4', '左模糊', 'LEFT_LIKE', NULL, '左模糊', 7, 1, 'admin', '2020-03-02 14:55:27', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1234371809495760898', '4e4602b3e3686f0911384e188dc7efb4', '右模糊', 'RIGHT_LIKE', NULL, '右模糊', 7, 1, 'admin', '2020-03-02 14:55:47', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1242300779390357505', '1242298510024429569', '短信提醒', '2', NULL, '', 2, 1, 'admin', '2020-03-24 12:02:41', 'admin', '2020-03-30 18:21:33');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1242300814383435777', '1242298510024429569', '邮件提醒', '1', NULL, '', 1, 1, 'admin', '2020-03-24 12:02:49', 'admin', '2020-03-30 18:21:26');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1242300887343353857', '1242298510024429569', '系统消息', '4', NULL, '', 4, 1, 'admin', '2020-03-24 12:03:07', 'admin', '2020-03-30 18:21:43');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1280401815068295170', '1280401766745718786', '正常', '1', NULL, '', 1, 1, 'admin', '2020-07-07 15:22:36', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1280401847607705602', '1280401766745718786', '冻结', '0', NULL, '', 1, 1, 'admin', '2020-07-07 15:22:44', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1305827309355302914', 'bd1b8bc28e65d6feefefb6f3c79f42fd', 'API', 'api', NULL, '', 3, 1, 'admin', '2020-09-15 19:14:26', 'admin', '2020-09-15 19:14:41');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1334440962954936321', '1209733563293962241', 'MYSQL5.7+', '4', NULL, '', 2, 1, 'admin', '2020-12-03 18:16:02', 'admin', '2021-07-15 13:44:29');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1356445705549975553', '1356445645198135298', '是', 'Y', NULL, '', 1, 1, 'admin', '2021-02-02 11:33:52', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1356445754212290561', '1356445645198135298', '否', 'N', NULL, '', 1, 1, 'admin', '2021-02-02 11:34:04', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1414837074500976641', '1209733563293962241', 'postgresql', '6', NULL, '', 5, 1, 'admin', '2021-07-13 14:40:20', 'admin', '2021-07-15 13:44:15');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1415547541091504129', '1209733563293962241', 'marialDB', '5', NULL, '', 6, 1, 'admin', '2021-07-15 13:43:28', 'admin', '2021-07-15 13:44:23');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1418049969003089922', '1209733563293962241', '达梦', '7', NULL, '', 7, 1, 'admin', '2021-07-22 11:27:13', 'admin', '2021-07-22 11:27:30');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1418050017053036545', '1209733563293962241', '人大金仓', '8', NULL, '', 8, 1, 'admin', '2021-07-22 11:27:25', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1418050075555188737', '1209733563293962241', '神通', '9', NULL, '', 9, 1, 'admin', '2021-07-22 11:27:39', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1418050110669901826', '1209733563293962241', 'SQLite', '10', NULL, '', 10, 1, 'admin', '2021-07-22 11:27:47', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1418050149475602434', '1209733563293962241', 'DB2', '11', NULL, '', 11, 1, 'admin', '2021-07-22 11:27:56', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1418050209823248385', '1209733563293962241', 'Hsqldb', '12', NULL, '', 12, 1, 'admin', '2021-07-22 11:28:11', 'admin', '2021-07-22 11:28:27');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1418050323111399425', '1209733563293962241', 'Derby', '13', NULL, '', 13, 1, 'admin', '2021-07-22 11:28:38', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1418117316707590146', '1209733563293962241', 'H2', '14', NULL, '', 14, 1, 'admin', '2021-07-22 15:54:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1418491604048449537', '1209733563293962241', '其他数据库', '15', NULL, '', 15, 1, 'admin', '2021-07-23 16:42:07', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('147c48ff4b51545032a9119d13f3222a', 'd6e1152968b02d69ff358c75b48a6ee1', '测试流程', 'test', NULL, NULL, 1, 1, 'admin', '2019-03-22 19:27:05', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1543fe7e5e26fb97cdafe4981bedc0c8', '4c03fca6bf1f0299c381213961566349', '单排布局', 'single', NULL, NULL, 2, 1, 'admin', '2022-07-12 17:43:39', 'admin', '2019-04-12 17:43:57');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600042651777011713', '1600042215909134338', '信息传输、软件和信息技术服务业', '1', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:21:10', 'admin', '2022-12-06 16:21:27');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600042736254488578', '1600042215909134338', '制造业', '2', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:21:30', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600042785646612481', '1600042215909134338', '租赁和商务服务业', '3', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:21:42', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600042835433000961', '1600042215909134338', '教育', '4', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:21:54', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600042892072882177', '1600042215909134338', '金融业', '5', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:22:07', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600042975539531778', '1600042215909134338', '建筑业', '6', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:22:27', 'admin', '2022-12-06 16:22:32');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043052177854466', '1600042215909134338', '科学研究和技术服务业', '7', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:22:46', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043101976825857', '1600042215909134338', '批发和零售业', '8', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:22:58', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043157069008898', '1600042215909134338', '住宿和餐饮业', '9', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:23:11', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043203105689601', '1600042215909134338', '电子商务', '10', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:23:22', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043277504253953', '1600042215909134338', '线下零售与服务业', '11', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:23:39', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043334618091521', '1600042215909134338', '文化、体育和娱乐业', '12', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:23:53', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043401030701058', '1600042215909134338', '房地产业', '13', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:24:09', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043476440092673', '1600042215909134338', '交通运输、仓储和邮政业', '14', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:24:27', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043553837584386', '1600042215909134338', '卫生和社会工作', '15', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:24:45', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043628793991170', '1600042215909134338', '公共管理、社会保障和社会组织', '16', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:25:03', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043675329794050', '1600042215909134338', '电力、热力、燃气及水生产和供应业', '18', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:25:14', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043734607892482', '1600042215909134338', '水利、环境和公共设施管理业', '19', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:25:28', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043783068880897', '1600042215909134338', '居民服务、修理和其他服务业', '20', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:25:40', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043822679887874', '1600042215909134338', '政府机构', '21', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:25:49', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043859539431426', '1600042215909134338', '农、林、牧、渔业', '22', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:25:58', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043907551629313', '1600042215909134338', '采矿业', '23', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:26:10', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043955731599362', '1600042215909134338', '国际组织', '24', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:26:21', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600043991685173249', '1600042215909134338', '其他', '25', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:26:30', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600044644096577538', '1600044537800331266', '20人以下', '1', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:29:05', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600044698618335233', '1600044537800331266', '21-99人', '2', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:29:18', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600044744172670978', '1600044537800331266', '100-499人', '3', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:29:29', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600044792306503681', '1600044537800331266', '500-999人', '4', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:29:41', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600044861302804481', '1600044537800331266', '1000-9999人', '5', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:29:57', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1600044924313833473', '1600044537800331266', '10000人以上', '6', NULL, NULL, 1, 1, 'admin', '2022-12-06 16:30:12', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606645562573361153', '1606645341269299201', '总裁/总经理/CEO', '1', NULL, NULL, 1, 1, 'admin', '2022-12-24 21:38:47', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606645619930468354', '1606645341269299201', '副总裁/副总经理/VP', '2', NULL, NULL, 2, 1, 'admin', '2022-12-24 21:39:00', 'admin', '2022-12-24 21:40:00');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606645660241924097', '1606645341269299201', '总监/主管/经理', '3', NULL, NULL, 3, 1, 'admin', '2022-12-24 21:39:10', 'admin', '2022-12-24 21:39:41');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606645696715591682', '1606645341269299201', '员工/专员/执行', '4', NULL, NULL, 4, 1, 'admin', '2022-12-24 21:39:19', 'admin', '2022-12-24 21:39:37');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606645744023146497', '1606645341269299201', '其他', '5', NULL, NULL, 5, 1, 'admin', '2022-12-24 21:39:30', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606647668965412866', '1606646440684457986', '总经办', '1', NULL, NULL, 1, 1, 'admin', '2022-12-24 21:47:09', 'admin', '2023-10-18 13:54:03');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606647703098658817', '1606646440684457986', '技术/IT/研发', '2', NULL, NULL, 2, 1, 'admin', '2022-12-24 21:47:17', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606647737919770625', '1606646440684457986', '产品/设计', '3', NULL, NULL, 3, 1, 'admin', '2022-12-24 21:47:25', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606647789614567425', '1606646440684457986', '销售/市场/运营', '4', NULL, '', 4, 1, 'admin', '2022-12-24 21:47:38', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606647827921145857', '1606646440684457986', '人事/财务/行政', '5', NULL, NULL, 5, 1, 'admin', '2022-12-24 21:47:47', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606647860955484162', '1606646440684457986', '资源/仓储/采购', '6', NULL, NULL, 6, 1, 'admin', '2022-12-24 21:47:55', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1606647915473047553', '1606646440684457986', '其他', '7', NULL, NULL, 7, 1, 'admin', '2022-12-24 21:48:08', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1782325511230337025', '83bfb33147013cc81640d5fd9eda030c', '租户操作日志', '3', NULL, NULL, 1, 1, 'admin', '2024-04-22 16:28:11', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1783383857978970114', '83bfb33147013cc81640d5fd9eda030c', '异常日志', '4', NULL, NULL, 3, 1, 'jeecg', '2024-04-25 14:33:40', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1784843259509161986', '1784843187992084482', '电脑终端', 'pc', NULL, NULL, 1, 1, 'jeecg', '2024-04-29 15:12:49', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1784843314429378562', '1784843187992084482', '手机APP端', 'app', NULL, NULL, 1, 1, 'jeecg', '2024-04-29 15:13:02', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1784843380502249474', '1784843187992084482', '移动网页端', 'h5', NULL, NULL, 1, 1, 'jeecg', '2024-04-29 15:13:17', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1890229967585910786', '1890229208685322242', 'OpenAI', 'OPENAI', NULL, NULL, 1, 1, 'jeecg', '2025-02-14 10:41:58', 'jeecg', '2025-02-14 10:42:48');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1890230018852888577', '1890229208685322242', '智谱AI', 'ZHIPU', NULL, NULL, 1, 1, 'jeecg', '2025-02-14 10:42:10', 'jeecg', '2025-02-14 10:42:42');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1890230107835047937', '1890229208685322242', '千帆大模型', 'QIANFAN', NULL, NULL, 1, 1, 'jeecg', '2025-02-14 10:42:31', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1890230305948803073', '1890229208685322242', '通义千问', 'QWEN', NULL, NULL, 1, 1, 'jeecg', '2025-02-14 10:43:18', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1890230384159989762', '1890229208685322242', 'DeepSeek', 'DEEPSEEK', NULL, NULL, 1, 1, 'jeecg', '2025-02-14 10:43:37', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1890230437670920194', '1890229208685322242', 'Ollama', 'OLLAMA', NULL, NULL, 1, 1, 'jeecg', '2025-02-14 10:43:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1891456733029613569', '1891456510739890177', '语言模型', 'LLM', NULL, NULL, 1, 1, 'jeecg', '2025-02-17 19:56:41', 'jeecg', '2025-02-17 20:02:15');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1891458099609354241', '1891456510739890177', '向量模型', 'EMBED', NULL, NULL, 1, 1, 'jeecg', '2025-02-17 20:02:07', 'jeecg', '2025-02-17 20:39:01');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1891672501432479746', '1891672414555860993', '文本', 'text', NULL, NULL, 1, 1, 'jeecg', '2025-02-18 10:14:05', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1891672540963794946', '1891672414555860993', '文件', 'file', NULL, NULL, 1, 1, 'jeecg', '2025-02-18 10:14:14', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1891672567924781058', '1891672414555860993', '网页', 'web', NULL, NULL, 1, 1, 'jeecg', '2025-02-18 10:14:20', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1894701277019959298', '1894701158027554818', '简单配置', 'chatSimple', NULL, NULL, 1, 1, 'jeecg', '2025-02-26 18:49:21', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1894701332930031618', '1894701158027554818', '高级编排', 'chatFLow', NULL, NULL, 2, 1, 'jeecg', '2025-02-26 18:49:34', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1937394006326460418', '1937393911539384322', '通知公告', 'notice', NULL, NULL, 1, 1, 'admin', '2025-06-24 14:15:01', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1937394038412886018', '1937393911539384322', '其他', 'other', NULL, NULL, 1, 1, 'admin', '2025-06-24 14:15:08', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1939572554533429250', '1939572486447292418', '角色', 'ROLE', NULL, NULL, 1, 1, 'admin', '2025-06-30 14:31:47', 'admin', '2025-06-30 15:04:18');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1939572602289774594', '1939572486447292418', '用户', 'USER', NULL, NULL, 2, 1, 'admin', '2025-06-30 14:31:59', 'admin', '2025-06-30 15:04:21');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955230463631126529', '1174511106530525185', '子公司', '4', NULL, NULL, 1, 1, 'admin', '2025-08-12 19:30:44', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1963079150651305985', '1939572486447292418', '全局默认', 'DEFAULT', NULL, NULL, 3, 1, 'admin', '2025-09-03 11:18:36', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1ce390c52453891f93514c1bd2795d44', 'ad7c65ba97c20a6805d5dcdf13cdaf36', '000', '00', NULL, NULL, 1, 1, 'admin', '2019-03-22 16:34:34', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1db531bcff19649fa82a644c8a939dc4', '4c03fca6bf1f0299c381213961566349', '组合布局', 'combination', NULL, '', 4, 1, 'admin', '2019-05-11 16:07:08', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('222705e11ef0264d4214affff1fb4ff9', '4f69be5f507accea8d5df5f11346181a', '文本', '1', NULL, '', 1, 1, 'admin', '2023-02-28 10:50:36', 'admin', '2022-07-04 16:29:21');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('23a5bb76004ed0e39414e928c4cde155', '4e4602b3e3686f0911384e188dc7efb4', '不等于', '!=', NULL, '不等于', 3, 1, 'admin', '2019-04-01 16:46:15', 'admin', '2019-04-01 17:48:40');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('25847e9cb661a7c711f9998452dc09e6', '4e4602b3e3686f0911384e188dc7efb4', '小于等于', '<=', NULL, '小于等于', 6, 1, 'admin', '2019-04-01 16:44:34', 'admin', '2019-04-01 17:49:10');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2d51376643f220afdeb6d216a8ac2c01', '68168534ff5065a152bfab275c2136f8', '有效', '1', NULL, '有效', 2, 1, 'admin', '2019-04-26 19:22:01', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('308c8aadf0c37ecdde188b97ca9833f5', '8dfe32e2d29ea9430a988b3b558bf233', '已发布', '1', NULL, '已发布', 2, 1, 'admin', '2019-04-16 17:41:24', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('333e6b2196e01ef9a5f76d74e86a6e33', '8dfe32e2d29ea9430a988b3b558bf233', '未发布', '0', NULL, '未发布', 1, 1, 'admin', '2019-04-16 17:41:12', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('337ea1e401bda7233f6258c284ce4f50', 'bd1b8bc28e65d6feefefb6f3c79f42fd', 'JSON', 'json', NULL, NULL, 1, 1, 'admin', '2019-04-12 17:26:33', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('33bc9d9f753cf7dc40e70461e50fdc54', 'a9d9942bd0eccb6e89de92d130ec4c4a', '发送失败', '2', NULL, NULL, 3, 1, 'admin', '2019-04-12 18:20:02', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('3fbc03d6c994ae06d083751248037c0e', '78bda155fe380b1b3f175f1e88c284c6', '已完成', '3', NULL, '已完成', 3, 1, 'admin', '2019-05-09 16:33:25', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('41d7aaa40c9b61756ffb1f28da5ead8e', '0b5d19e1fce4b2e6647e6b4a17760c14', '通知公告', '1', NULL, NULL, 1, 1, 'admin', '2019-04-22 18:01:57', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('41fa1e9571505d643aea87aeb83d4d76', '4e4602b3e3686f0911384e188dc7efb4', '等于', '=', NULL, '等于', 4, 1, 'admin', '2019-04-01 16:45:24', 'admin', '2019-04-01 17:49:00');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('43d2295b8610adce9510ff196a49c6e9', '845da5006c97754728bf48b6a10f79cc', '正常', '1', NULL, NULL, NULL, 1, 'admin', '2019-03-18 21:45:51', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('4f05fb5376f4c61502c5105f52e4dd2b', '83bfb33147013cc81640d5fd9eda030c', '操作日志', '2', NULL, NULL, NULL, 1, 'admin', '2019-03-18 23:22:49', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('50223341bfb5ba30bf6319789d8d17fe', 'd6e1152968b02d69ff358c75b48a6ee1', '业务办理', 'business', NULL, NULL, 3, 1, 'admin', '2023-04-22 19:28:05', 'admin', '2019-03-22 23:24:39');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('51222413e5906cdaf160bb5c86fb827c', 'a7adbcd86c37f7dbc9b66945c82ef9e6', '是', '1', NULL, '', 1, 1, 'admin', '2019-05-22 19:29:45', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('538fca35afe004972c5f3947c039e766', '2e02df51611a4b9632828ab7e5338f00', '显示', '1', NULL, '显示', 1, 1, 'admin', '2025-03-26 18:27:13', 'admin', '2019-04-26 18:39:07');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('5584c21993bde231bbde2b966f2633ac', '4e4602b3e3686f0911384e188dc7efb4', '自定义SQL表达式', 'USE_SQL_RULES', NULL, '自定义SQL表达式', 9, 1, 'admin', '2019-04-01 10:45:24', 'admin', '2019-04-01 17:49:27');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('58b73b344305c99b9d8db0fc056bbc0a', '72cce0989df68887546746d8f09811aa', '主表', '2', NULL, NULL, 2, 1, 'admin', '2019-03-27 10:13:36', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('5b65a88f076b32e8e69d19bbaadb52d5', '2f0320997ade5dd147c90130f7218c3e', '全体用户', 'ALL', NULL, NULL, NULL, 1, 'admin', '2020-10-17 21:22:43', 'admin', '2019-03-28 22:17:09');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('5d833f69296f691843ccdd0c91212b6b', '880a895c98afeca9d9ac39f29e67c13e', '修改', '3', NULL, '', 3, 1, 'admin', '2019-07-22 10:55:07', 'admin', '2019-07-22 10:55:41');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('5d84a8634c8fdfe96275385075b105c9', '3d9a351be3436fbefb1307d4cfb49bf2', '女', '2', NULL, NULL, 2, 1, NULL, '2019-01-04 14:56:56', NULL, '2019-01-04 17:38:12');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('66c952ae2c3701a993e7db58f3baf55e', '4e4602b3e3686f0911384e188dc7efb4', '大于', '>', NULL, '大于', 1, 1, 'admin', '2019-04-01 10:45:46', 'admin', '2019-04-01 17:48:29');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('6937c5dde8f92e9a00d4e2ded9198694', 'ad7c65ba97c20a6805d5dcdf13cdaf36', 'easyui', '3', NULL, NULL, 1, 1, 'admin', '2019-03-22 16:32:15', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('69cacf64e244100289ddd4aa9fa3b915', 'a9d9942bd0eccb6e89de92d130ec4c4a', '未发送', '0', NULL, NULL, 1, 1, 'admin', '2019-04-12 18:19:23', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('6a7a9e1403a7943aba69e54ebeff9762', '4f69be5f507accea8d5df5f11346181a', '富文本', '2', NULL, '', 2, 1, 'admin', '2031-02-28 10:50:44', 'admin', '2022-07-04 16:29:30');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('6c682d78ddf1715baf79a1d52d2aa8c2', '72cce0989df68887546746d8f09811aa', '单表', '1', NULL, NULL, 1, 1, 'admin', '2019-03-27 10:13:29', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('6d404fd2d82311fbc87722cd302a28bc', '4e4602b3e3686f0911384e188dc7efb4', '模糊', 'LIKE', NULL, '模糊', 7, 1, 'admin', '2019-04-01 16:46:02', 'admin', '2019-04-01 17:49:20');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('6d4e26e78e1a09699182e08516c49fc4', '4d7fec1a7799a436d26d02325eff295e', '高', 'H', NULL, '高', 1, 1, 'admin', '2019-04-16 17:04:24', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('700e9f030654f3f90e9ba76ab0713551', '6b78e3f59faec1a4750acff08030a79b', '333', '333', NULL, NULL, NULL, 1, 'admin', '2019-02-21 19:59:47', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('7050c1522702bac3be40e3b7d2e1dfd8', 'c5a14c75172783d72cbee6ee7f5df5d1', '柱状图', 'bar', NULL, NULL, 1, 1, 'admin', '2019-04-12 17:05:17', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('71b924faa93805c5c1579f12e001c809', 'd6e1152968b02d69ff358c75b48a6ee1', 'OA办公', 'oa', NULL, NULL, 2, 1, 'admin', '2021-03-22 19:27:17', 'admin', '2023-10-18 13:54:29');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('75b260d7db45a39fc7f21badeabdb0ed', 'c36169beb12de8a71c8683ee7c28a503', '不启用', '0', NULL, NULL, NULL, 1, 'admin', '2019-03-18 23:29:41', 'admin', '2019-03-18 23:29:54');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('7688469db4a3eba61e6e35578dc7c2e5', 'c36169beb12de8a71c8683ee7c28a503', '启用', '1', NULL, NULL, NULL, 1, 'admin', '2019-03-18 23:29:28', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('78ea6cadac457967a4b1c4eb7aaa418c', 'fc6cd58fde2e8481db10d3a1e68ce70c', '正常', '1', NULL, NULL, NULL, 1, 'admin', '2019-03-18 23:30:28', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('7ccf7b80c70ee002eceb3116854b75cb', 'ac2f7c0c5c5775fcea7e2387bcb22f01', '按钮权限', '2', NULL, NULL, NULL, 1, 'admin', '2019-03-18 23:25:40', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('81fb2bb0e838dc68b43f96cc309f8257', 'fc6cd58fde2e8481db10d3a1e68ce70c', '冻结', '2', NULL, NULL, NULL, 1, 'admin', '2019-03-18 23:30:37', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('83250269359855501ec4e9c0b7e21596', '4274efc2292239b6f000b153f50823ff', '可见/可访问(授权后可见/可访问)', '1', NULL, '', 1, 1, 'admin', '2019-05-10 17:54:51', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('84778d7e928bc843ad4756db1322301f', '4e4602b3e3686f0911384e188dc7efb4', '大于等于', '>=', NULL, '大于等于', 5, 1, 'admin', '2019-04-01 10:46:02', 'admin', '2019-04-01 17:49:05');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('848d4da35ebd93782029c57b103e5b36', 'c5a14c75172783d72cbee6ee7f5df5d1', '饼图', 'pie', NULL, NULL, 3, 1, 'admin', '2019-04-12 17:05:49', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('84dfc178dd61b95a72900fcdd624c471', '78bda155fe380b1b3f175f1e88c284c6', '处理中', '2', NULL, '处理中', 2, 1, 'admin', '2019-05-09 16:33:01', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('86f19c7e0a73a0bae451021ac05b99dd', 'ac2f7c0c5c5775fcea7e2387bcb22f01', '子菜单', '1', NULL, NULL, NULL, 1, 'admin', '2019-03-18 23:25:27', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('8802daf8d73a11f08076525400e87d0c', '2f0320997ade5dd147c90130f7218c3e', '顶级代理', 'TOP_AGENT', NULL, '推送给所有顶级代理用户（无上级或上级是admin或上级ID=999）', 2, 1, 'admin', '2025-12-12 17:11:23', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('8c618902365ca681ebbbe1e28f11a548', '4c753b5293304e7a445fd2741b46529d', '启用', '1', NULL, '', 0, 1, 'admin', '2020-07-18 23:19:27', 'admin', '2019-05-17 14:51:18');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('8cdf08045056671efd10677b8456c999', '4274efc2292239b6f000b153f50823ff', '可编辑(未授权时禁用)', '2', NULL, '', 2, 1, 'admin', '2019-05-10 17:55:38', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('8ff48e657a7c5090d4f2a59b37d1b878', '4d7fec1a7799a436d26d02325eff295e', '中', 'M', NULL, '中', 2, 1, 'admin', '2019-04-16 17:04:40', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('948923658baa330319e59b2213cda97c', '880a895c98afeca9d9ac39f29e67c13e', '添加', '2', NULL, '', 2, 1, 'admin', '2019-07-22 10:54:59', 'admin', '2019-07-22 10:55:36');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('97b91178d66011f08076525400e87d0c', '977df2e4d66011f08076525400e87d0c', '订单问题', 'order_issue', NULL, '订单相关问题', 1, 1, 'system', '2025-12-11 15:11:19', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('97d89889d66011f08076525400e87d0c', '977df2e4d66011f08076525400e87d0c', '课程问题', 'course_issue', NULL, '课程内容或进度问题', 2, 1, 'system', '2025-12-11 15:11:20', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('97fbfa61d66011f08076525400e87d0c', '977df2e4d66011f08076525400e87d0c', '退款问题', 'refund_issue', NULL, '退款申请相关问题', 3, 1, 'system', '2025-12-11 15:11:20', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('9818b4ead66011f08076525400e87d0c', '977df2e4d66011f08076525400e87d0c', '其他问题', 'other', NULL, '其他类型问题', 4, 1, 'system', '2025-12-11 15:11:20', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('9a96c4a4e4c5c9b4e4d0cbf6eb3243cc', '4c753b5293304e7a445fd2741b46529d', '不启用', '0', NULL, NULL, 1, 1, 'admin', '2019-03-18 23:19:53', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('a1e7d1ca507cff4a480c8caba7c1339e', '880a895c98afeca9d9ac39f29e67c13e', '导出', '6', NULL, '', 6, 1, 'admin', '2019-07-22 12:06:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('a2be752dd4ec980afaec1efd1fb589af', '8dfe32e2d29ea9430a988b3b558bf233', '已撤销', '2', NULL, '已撤销', 3, 1, 'admin', '2019-04-16 17:41:39', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('aa0d8a8042a18715a17f0a888d360aa4', 'ac2f7c0c5c5775fcea7e2387bcb22f01', '一级菜单', '0', NULL, NULL, NULL, 1, 'admin', '2019-03-18 23:24:52', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('adapter_type_aishen', 'adapter_type_dict_id', 'AI神', 'aishen', NULL, 'AI神平台适配器', 7, 1, 'admin', '2025-11-12 23:46:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('adapter_type_aixuexi', 'adapter_type_dict_id', '爱学习', 'aixuexi', NULL, '爱学习平台适配器', 1, 1, 'admin', '2025-11-12 23:46:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('adapter_type_huotui', 'adapter_type_dict_id', '火推', 'huotui', NULL, '火推平台适配器', 5, 1, 'admin', '2025-11-12 23:46:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('adapter_type_hzw', 'adapter_type_dict_id', '海贼王', 'hzw', NULL, '海贼王平台适配器', 2, 1, 'admin', '2025-11-12 23:46:50', 'admin', '2025-11-13 01:19:33');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('adapter_type_jingyu', 'adapter_type_dict_id', '精育', 'jingyu', NULL, '精育平台适配器', 6, 1, 'admin', '2025-11-12 23:46:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('adapter_type_longlong', 'adapter_type_dict_id', '龙龙', 'longlong', NULL, '龙龙平台适配器', 9, 1, 'admin', '2025-11-12 23:46:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('adapter_type_pangu', 'adapter_type_dict_id', '盘古', 'pangu', NULL, '盘古平台适配器', 3, 1, 'admin', '2025-11-12 23:46:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('adapter_type_tutu', 'adapter_type_dict_id', '兔兔', 'tutu', NULL, '兔兔平台适配器', 8, 1, 'admin', '2025-11-12 23:46:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('adapter_type_ydsj', 'adapter_type_dict_id', '易读书架', 'ydsj', NULL, '易读书架平台适配器', 4, 1, 'admin', '2025-11-12 23:46:50', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('adcf2a1fe93bb99a84833043f475fe0b', '4e4602b3e3686f0911384e188dc7efb4', '包含', 'IN', NULL, '包含', 8, 1, 'admin', '2019-04-01 16:45:47', 'admin', '2019-04-01 17:49:24');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('b029a41a851465332ee4ee69dcf0a4c2', '0b5d19e1fce4b2e6647e6b4a17760c14', '系统消息', '2', NULL, NULL, 1, 1, 'admin', '2019-02-22 18:02:08', 'admin', '2019-04-22 18:02:13');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('b2a8b4bb2c8e66c2c4b1bb086337f393', '3486f32803bb953e7155dab3513dc68b', '正常', '0', NULL, NULL, NULL, 1, 'admin', '2022-10-18 21:46:48', 'admin', '2019-03-28 22:22:20');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('b57f98b88363188daf38d42f25991956', '6b78e3f59faec1a4750acff08030a79b', '22', '222', NULL, NULL, NULL, 0, 'admin', '2019-02-21 19:59:43', 'admin', '2019-03-11 21:23:27');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('b5f3bd5f66bb9a83fecd89228c0d93d1', '68168534ff5065a152bfab275c2136f8', '无效', '0', NULL, '无效', 1, 1, 'admin', '2019-04-26 19:21:49', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('b9fbe2a3602d4a27b45c100ac5328484', '78bda155fe380b1b3f175f1e88c284c6', '待提交', '1', NULL, '待提交', 1, 1, 'admin', '2019-05-09 16:32:35', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('ba27737829c6e0e582e334832703d75e', '236e8a4baff0db8c62c00dd95632834f', '同步', '1', NULL, '同步', 1, 1, 'admin', '2019-05-15 15:28:15', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('bcec04526b04307e24a005d6dcd27fd6', '880a895c98afeca9d9ac39f29e67c13e', '导入', '5', NULL, '', 5, 1, 'admin', '2019-07-22 12:06:41', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('c53da022b9912e0aed691bbec3c78473', '880a895c98afeca9d9ac39f29e67c13e', '查询', '1', NULL, '', 1, 1, 'admin', '2019-07-22 10:54:51', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('c5700a71ad08994d18ad1dacc37a71a9', 'a7adbcd86c37f7dbc9b66945c82ef9e6', '否', '0', NULL, '', 1, 1, 'admin', '2019-05-22 19:29:55', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('cbfcc5b88fc3a90975df23ffc8cbe29c', 'c5a14c75172783d72cbee6ee7f5df5d1', '曲线图', 'line', NULL, NULL, 2, 1, 'admin', '2019-05-12 17:05:30', 'admin', '2019-04-12 17:06:06');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('d217592908ea3e00ff986ce97f24fb98', 'c5a14c75172783d72cbee6ee7f5df5d1', '数据列表', 'table', NULL, NULL, 4, 1, 'admin', '2019-04-12 17:05:56', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('df168368dcef46cade2aadd80100d8aa', '3d9a351be3436fbefb1307d4cfb49bf2', '男', '1', NULL, NULL, 1, 1, NULL, '2027-08-04 14:56:49', 'admin', '2019-03-23 22:44:44');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('e6329e3a66a003819e2eb830b0ca2ea0', '4e4602b3e3686f0911384e188dc7efb4', '小于', '<', NULL, '小于', 2, 1, 'admin', '2019-04-01 16:44:15', 'admin', '2019-04-01 17:48:34');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('e94eb7af89f1dbfa0d823580a7a6e66a', '236e8a4baff0db8c62c00dd95632834f', '不同步', '0', NULL, '不同步', 2, 1, 'admin', '2019-05-15 15:28:28', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('f0162f4cc572c9273f3e26b2b4d8c082', 'ad7c65ba97c20a6805d5dcdf13cdaf36', 'booostrap', '1', NULL, NULL, 1, 1, 'admin', '2021-08-22 16:32:04', 'admin', '2019-03-22 16:33:57');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('f16c5706f3ae05c57a53850c64ce7c45', 'a9d9942bd0eccb6e89de92d130ec4c4a', '发送成功', '1', NULL, NULL, 2, 1, 'admin', '2019-04-12 18:19:43', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('f2a7920421f3335afdf6ad2b342f6b5d', '845da5006c97754728bf48b6a10f79cc', '冻结', '2', NULL, NULL, NULL, 1, 'admin', '2019-03-18 21:46:02', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('f303fae0e30b11f08076525400e87d0c', '1934846825077878786', '系统公告', '1', NULL, NULL, 1, 1, 'admin', '2025-12-27 18:08:10', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('f3040182e30b11f08076525400e87d0c', '1934846825077878786', '活动通知', '2', NULL, NULL, 2, 1, 'admin', '2025-12-27 18:08:10', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('f304034ce30b11f08076525400e87d0c', '1934846825077878786', '价格调整', '3', NULL, NULL, 3, 1, 'admin', '2025-12-27 18:08:10', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('f304049fe30b11f08076525400e87d0c', '1934846825077878786', '平台维护', '4', NULL, NULL, 4, 1, 'admin', '2025-12-27 18:08:10', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('f37f90c496ec9841c4c326b065e00bb2', '83bfb33147013cc81640d5fd9eda030c', '登录日志', '1', NULL, NULL, NULL, 1, 'admin', '2019-03-18 23:22:37', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('f753aff60ff3931c0ecb4812d8b5e643', '4c03fca6bf1f0299c381213961566349', '双排布局', 'double', NULL, NULL, 3, 1, 'admin', '2019-04-12 17:43:51', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('f80a8f6838215753b05e1a5ba3346d22', '880a895c98afeca9d9ac39f29e67c13e', '删除', '4', NULL, '', 4, 1, 'admin', '2019-07-22 10:55:14', 'admin', '2019-07-22 10:55:30');
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('fcec03570f68a175e1964808dc3f1c91', '4c03fca6bf1f0299c381213961566349', 'Tab风格', 'tab', NULL, NULL, 1, 1, 'admin', '2019-04-12 17:43:31', NULL, NULL);
INSERT INTO `sys_dict_item` (`id`, `dict_id`, `item_text`, `item_value`, `item_color`, `description`, `sort_order`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('fe50b23ae5e68434def76f67cef35d2d', '78bda155fe380b1b3f175f1e88c284c6', '已作废', '4', NULL, '已作废', 4, 1, 'admin', '2021-09-09 16:33:43', 'admin', '2019-05-09 16:34:40');
COMMIT;

-- ----------------------------
-- Table structure for sys_fill_rule
-- ----------------------------
DROP TABLE IF EXISTS `sys_fill_rule`;
CREATE TABLE `sys_fill_rule` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `rule_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则名称',
  `rule_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则Code',
  `rule_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则实现类',
  `rule_params` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '规则参数',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '修改人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_sfr_rule_code` (`rule_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='填值规则表';

-- ----------------------------
-- Records of sys_fill_rule
-- ----------------------------
BEGIN;
INSERT INTO `sys_fill_rule` (`id`, `rule_name`, `rule_code`, `rule_class`, `rule_params`, `update_by`, `update_time`, `create_by`, `create_time`) VALUES ('1202551334738382850', '机构编码生成', 'org_num_role', 'org.jeecg.modules.system.rule.OrgCodeRule', '{\"parentId\":\"c6d7cb4deeac411cb3384b1b31278596\"}', 'admin', '2019-12-09 10:37:06', 'admin', '2019-12-05 19:32:35');
INSERT INTO `sys_fill_rule` (`id`, `rule_name`, `rule_code`, `rule_class`, `rule_params`, `update_by`, `update_time`, `create_by`, `create_time`) VALUES ('1202787623203065858', '分类字典编码生成', 'category_code_rule', 'org.jeecg.modules.system.rule.CategoryCodeRule', '{\"pid\":\"\"}', 'admin', '2022-10-13 16:47:52', 'admin', '2019-12-06 11:11:31');
INSERT INTO `sys_fill_rule` (`id`, `rule_name`, `rule_code`, `rule_class`, `rule_params`, `update_by`, `update_time`, `create_by`, `create_time`) VALUES ('1260134137920090113', '订单流水号', 'shop_order_num', 'org.jeecg.modules.online.cgform.rule.OrderNumberRule', '{}', 'admin', '2020-12-07 18:29:50', 'admin', '2020-05-12 17:06:05');
COMMIT;

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `log_type` int DEFAULT NULL COMMENT '日志类型（1登录日志，2操作日志, 3.租户操作日志）',
  `log_content` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '日志内容',
  `operate_type` int DEFAULT NULL COMMENT '操作类型',
  `userid` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作用户账号',
  `username` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作用户名称',
  `ip` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'IP',
  `method` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '请求java方法',
  `request_url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '请求路径',
  `request_param` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT '请求参数',
  `request_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '请求类型',
  `cost_time` bigint DEFAULT NULL COMMENT '耗时',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `tenant_id` int DEFAULT NULL COMMENT '租户ID',
  `client_type` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '客户端类型 pc:电脑端 app:手机端 h5:移动网页端',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sl_userid` (`userid`) USING BTREE,
  KEY `idx_sl_log_type` (`log_type`) USING BTREE,
  KEY `idx_sl_operate_type` (`operate_type`) USING BTREE,
  KEY `idx_sl_create_time` (`create_time`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COMMENT='系统日志表';

-- ----------------------------
-- Records of sys_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键id',
  `parent_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '父id',
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '菜单标题',
  `url` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '路径',
  `component` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组件',
  `is_route` tinyint(1) DEFAULT '1' COMMENT '是否路由菜单: 0:不是  1:是（默认值1）',
  `component_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组件名字',
  `redirect` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '一级菜单跳转地址',
  `menu_type` int DEFAULT NULL COMMENT '菜单类型(0:一级菜单; 1:子菜单:2:按钮权限)',
  `perms` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '菜单权限编码',
  `perms_type` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '权限策略1显示2禁用',
  `sort_no` double(8,2) DEFAULT NULL COMMENT '菜单排序',
  `always_show` tinyint(1) DEFAULT NULL COMMENT '聚合子路由: 1是0否',
  `icon` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '菜单图标',
  `is_leaf` tinyint(1) DEFAULT NULL COMMENT '是否叶子节点:    1是0否',
  `keep_alive` tinyint(1) DEFAULT NULL COMMENT '是否缓存该页面:    1:是   0:不是',
  `hidden` tinyint DEFAULT '0' COMMENT '是否隐藏路由: 0否,1是',
  `hide_tab` tinyint DEFAULT NULL COMMENT '是否隐藏tab: 0否,1是',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `create_by` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` int DEFAULT '0' COMMENT '删除状态 0正常 1已删除',
  `rule_flag` int DEFAULT '0' COMMENT '是否添加数据权限1是0否',
  `status` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '按钮权限状态(0无效1有效)',
  `internal_or_external` tinyint(1) DEFAULT NULL COMMENT '外链菜单打开方式 0/内部打开 1/外部打开',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_menu_type` (`menu_type`) USING BTREE,
  KEY `index_menu_hidden` (`hidden`) USING BTREE,
  KEY `index_menu_status` (`status`) USING BTREE,
  KEY `index_menu_del_flag` (`del_flag`) USING BTREE,
  KEY `index_menu_url` (`url`) USING BTREE,
  KEY `index_menu_sort_no` (`sort_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='菜单权限表';

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1170592628746878978', 'd7d6e2e4e2934f2c9385a623fd98c6f3', '菜单管理', '/system/menu', 'system/menu/index', 1, NULL, NULL, 1, NULL, '1', 0.00, 0, 'ant-design:menu-fold-outlined', 0, 0, 0, 0, NULL, 'admin', '2019-09-08 15:00:05', 'ceshi', '2023-10-18 12:02:41', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('119213522910765570', '1674708136602542082', '租户用户', '/system/tenant/TenantUserList', 'system/tenant/TenantUserList', 1, 'tenant-system-user', NULL, 1, NULL, NULL, 2.00, 0, 'ant-design:user', 1, 0, 0, 0, NULL, NULL, '2018-12-25 20:34:38', 'admin', '2025-08-12 18:23:19', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1211885237487923202', '1207203817658105858', 'btn:add', '', '', 1, NULL, NULL, 2, 'btn:add', '1', 1.00, 0, NULL, 1, 0, 0, NULL, NULL, 'admin', '2019-12-31 13:42:11', 'admin', '2020-01-07 20:07:53', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1214376304951664642', '3f915b2769fc80648e92d04e84ca059d', '用户编辑', '', '', 0, NULL, NULL, 2, 'system:user:edit', '1', 1.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2020-01-07 10:40:47', 'admin', '2022-11-17 16:24:33', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1214462306546319322', '119213522910765570', '新增用户', '', '', 1, NULL, NULL, 2, 'system:user:addTenantUser', '1', 1.00, 0, NULL, 1, 0, 0, NULL, NULL, 'admin', '2020-01-07 16:22:32', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1214462306546319362', '3f915b2769fc80648e92d04e84ca059d', '新增用户', '', '', 0, NULL, NULL, 2, 'system:user:add', '1', 1.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2020-01-07 16:22:32', 'admin', '2022-11-17 16:24:47', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1280350452934307841', 'menu_operation', '分站授权', '/system/tenant', 'system/tenant/index', 1, NULL, NULL, 1, NULL, '1', 2.00, 0, 'ant-design:appstore-twotone', 0, 0, 0, 0, NULL, 'admin', '2020-07-07 11:58:30', 'admin', '2025-12-27 16:51:27', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1438108176273760258', '', '主页', '/dashboard', 'layouts/default/index', 1, NULL, '/dashboard/analysis', 0, NULL, '1', 1.00, 0, 'ant-design:home-outlined', 0, 0, 0, 0, NULL, 'admin', '2021-09-15 19:51:23', 'admin', '2025-09-13 18:49:01', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1438108176814825473', '1438108176273760258', '工作台', '/dashboard/workbench', 'dashboard/workbench/index', 1, NULL, NULL, 1, NULL, '1', 2.00, 0, 'ant-design:appstore-twotone', 1, 0, 0, 0, NULL, 'admin', '2021-09-15 19:51:23', 'jeecg', '2024-06-13 11:37:46', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1438782530717495298', 'd7d6e2e4e2934f2c9385a623fd98c6f3', '分类字典', '/system/category', 'system/category/index', 1, NULL, NULL, 1, NULL, '0', 9.00, 0, 'ant-design:group-outlined', 1, 0, 0, NULL, NULL, 'admin', '2021-09-17 16:31:01', NULL, NULL, 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1438782641187074050', 'd7d6e2e4e2934f2c9385a623fd98c6f3', '数据字典', '/system/dict', 'system/dict/index', 1, NULL, NULL, 1, NULL, '0', 4.00, 0, 'ant-design:hdd-twotone', 0, 0, 0, 0, NULL, 'admin', '2021-09-17 16:31:27', 'admin', '2023-03-04 15:01:55', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1438782851980210178', '1443390062919208961', '通知公告', '/system/notice', 'system/notice/index', 1, NULL, NULL, 1, NULL, '0', 8.00, 0, 'ant-design:bell-outlined', 1, 0, 0, 0, NULL, 'admin', '2021-09-17 16:32:17', 'admin', '2025-12-27 18:02:12', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1439398677984878593', '', '系统监控', '/monitor', 'layouts/RouteView', 1, NULL, NULL, 0, NULL, '0', 5.00, 0, 'ant-design:video-camera-filled', 0, 0, 0, 0, NULL, 'admin', '2021-09-19 09:19:22', 'admin', '2022-10-14 16:21:08', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1439531077792473089', '1439398677984878593', '数据日志', '/monitor/datalog', 'monitor/datalog/index', 1, NULL, NULL, 1, NULL, '0', 6.00, 0, 'ant-design:funnel-plot-twotone', 1, 0, 0, 0, NULL, 'admin', '2021-09-19 18:05:28', 'admin', '2025-06-25 16:45:47', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1439533711676973057', '1439398677984878593', '日志管理', '/monitor/log', 'monitor/log/index', 1, NULL, NULL, 1, NULL, '0', 5.00, 0, 'ant-design:interaction-outlined', 0, 0, 0, 0, NULL, 'admin', '2021-09-19 18:15:56', 'admin', '2021-09-19 18:16:56', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1439542701152575489', '1443390062919208961', '我的消息', '/monitor/mynews', 'monitor/mynews/index', 1, NULL, NULL, 1, NULL, '0', 6.00, 0, '', 1, 0, 0, 0, NULL, 'admin', '2021-09-19 18:51:40', 'admin', '2022-09-22 10:33:10', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1439784356766064642', '1439398677984878593', 'SQL监控', '/monitor/druid', '{{ window._CONFIG[\'domianURL\'] }}/druid', 1, NULL, NULL, 1, NULL, '0', 8.00, 0, 'ant-design:rocket-filled', 1, 0, 0, 0, NULL, 'admin', '2021-09-20 10:51:55', 'admin', '2021-11-15 18:21:20', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1439797053314342913', '1439398677984878593', '性能监控', '/monitor/server', 'monitor/server/index', 1, NULL, NULL, 1, NULL, '0', 9.00, 0, 'ant-design:thunderbolt-filled', 1, 0, 0, 0, NULL, 'admin', '2021-09-20 11:42:22', 'admin', '2021-09-20 14:13:14', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1439839507094740994', '1439398677984878593', 'Redis监控', '/monitor/redis', 'monitor/redis/index', 1, NULL, NULL, 1, NULL, '0', 10.00, 0, 'ant-design:trademark-outlined', 1, 0, 0, 0, NULL, 'admin', '2021-09-20 14:31:04', NULL, NULL, 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1439842640030113793', '1439398677984878593', '请求追踪', '/monitor/trace', 'monitor/trace/index', 1, NULL, NULL, 1, NULL, '0', 11.00, 0, 'ant-design:ie-circle-filled', 1, 0, 0, 0, NULL, 'admin', '2021-09-20 14:43:31', NULL, NULL, 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1443390062919208961', '', '消息中心', '/message', 'layouts/default/index', 1, NULL, '/message/manage', 0, NULL, '0', 7.00, 0, 'ant-design:message-outlined', 0, 0, 0, 0, NULL, 'admin', '2021-09-30 09:39:43', 'admin', '2025-07-31 11:32:02', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1443391584864358402', '1443390062919208961', '消息模板', '/message/template', 'system/message/template/index', 1, NULL, NULL, 1, NULL, '0', 2.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2021-09-30 09:45:45', 'admin', '2022-09-22 10:32:42', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1542385335362383873', '1473927410093187073', '删除仪表盘', NULL, NULL, 0, NULL, NULL, 2, 'onl:drag:page:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-06-30 13:51:35', 'admin', '2022-06-30 13:51:42', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1554384900763729922', '1473927410093187073', '模板设置', NULL, NULL, 0, NULL, NULL, 2, 'drag:template:edit', '2', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'jeecg', '2022-08-02 16:33:34', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1588513553652436993', '3f915b2769fc80648e92d04e84ca059d', '修改密码', NULL, NULL, 0, NULL, NULL, 2, 'system:user:changepwd', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-04 20:48:39', 'admin', '2022-11-04 20:49:06', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592102143467200514', '1597419994965786625', '给指定角色添加用户', NULL, NULL, 0, NULL, NULL, 2, 'system:user:addUserRole', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:18:49', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592112984361365505', '1170592628746878978', '添加菜单', NULL, NULL, 0, NULL, NULL, 2, 'system:permission:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:11:30', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592113148350263298', '190c2b43bec6a5f7a4194a85db67d96a', '保存角色授权', NULL, NULL, 0, NULL, NULL, 2, 'system:permission:saveRole', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:12:09', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592114574275211265', '3f915b2769fc80648e92d04e84ca059d', '删除用户', NULL, NULL, 0, NULL, NULL, 2, 'system:user:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:17:49', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592114574275211345', '119213522910765570', '删除用户', NULL, NULL, 0, NULL, NULL, 2, 'system:user:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:17:49', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592114652566089729', '3f915b2769fc80648e92d04e84ca059d', '批量删除用户', NULL, NULL, 0, NULL, NULL, 2, 'system:user:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:18:08', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592114721138765826', '3f915b2769fc80648e92d04e84ca059d', '冻结/解冻用户', NULL, NULL, 0, NULL, NULL, 2, 'system:user:frozenBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:18:24', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592114772665790465', '3f915b2769fc80648e92d04e84ca059d', '首页用户重置密码', NULL, NULL, 0, NULL, NULL, 2, 'system:user:updatepwd', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:18:37', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592114823467200514', '3f915b2769fc80648e92d04e84ca059d', '给指定角色添加用户', NULL, NULL, 0, NULL, NULL, 2, 'system:user:addUserRole', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:18:49', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592114893302362114', '3f915b2769fc80648e92d04e84ca059d', '删除指定角色的用户关系', NULL, NULL, 0, NULL, NULL, 2, 'system:user:deleteRole', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:19:05', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592114893302823614', '1597419994965786625', '删除指定角色的用户关系', NULL, NULL, 0, NULL, NULL, 2, 'system:user:deleteRole', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:19:05', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592114955650691074', '3f915b2769fc80648e92d04e84ca059d', '批量删除指定角色的用户关系', NULL, NULL, 0, NULL, NULL, 2, 'system:user:deleteRoleBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:19:20', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592114955650691174', '1597419994965786625', '批量删除指定角色的用户关系', NULL, NULL, 0, NULL, NULL, 2, 'system:user:deleteRoleBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:19:20', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592115070432014338', '3f915b2769fc80648e92d04e84ca059d', '给指定部门添加对应的用户', NULL, NULL, 0, NULL, NULL, 2, 'system:user:editDepartWithUser', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:19:48', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592115115361398786', '3f915b2769fc80648e92d04e84ca059d', '删除指定机构的用户关系', NULL, NULL, 0, NULL, NULL, 2, 'system:user:deleteUserInDepart', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:19:58', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592115162379546625', '3f915b2769fc80648e92d04e84ca059d', '批量删除指定机构的用户关系', NULL, NULL, 0, NULL, NULL, 2, 'system:user:deleteUserInDepartBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:20:09', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592115213910765570', '3f915b2769fc80648e92d04e84ca059d', '彻底删除用户', NULL, NULL, 0, NULL, NULL, 2, 'system:user:deleteRecycleBin', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:20:22', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592115712422330529', '1961009998209257473', '部门添加', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:22:21', 'admin', '2022-11-14 19:30:49', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592115712466710529', '45c966826eeff4c99b8f8ebfe74511fc', '部门添加', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:22:21', 'admin', '2022-11-14 19:30:49', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592115914493751297', '1170592628746878978', '编辑菜单权限数据', NULL, NULL, 0, NULL, NULL, 2, 'system:permission:editRule', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:23:09', 'admin', '2022-11-14 19:39:25', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592116663936184322', '1170592628746878978', '编辑菜单', NULL, NULL, 0, NULL, NULL, 2, 'system:permission:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:26:07', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117222764277032', '1961009998209257473', '部门编辑', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:28:21', 'admin', '2022-11-14 19:30:55', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117222764277761', '45c966826eeff4c99b8f8ebfe74511fc', '部门编辑', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:28:21', 'admin', '2022-11-14 19:30:55', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117276539449345', '45c966826eeff4c99b8f8ebfe74511fc', '部门删除', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:28:33', 'admin', '2022-11-14 19:31:06', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117276539449346', '1961009998209257473', '部门删除', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:28:33', 'admin', '2022-11-14 19:31:06', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117377299214337', '45c966826eeff4c99b8f8ebfe74511fc', '部门批量删除', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:28:58', 'admin', '2022-11-14 19:31:12', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117377299214338', '1961009998209257473', '部门批量删除', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:28:58', 'admin', '2022-11-14 19:31:12', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117422006300673', '45c966826eeff4c99b8f8ebfe74511fc', '部门导入', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:29:08', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117625664925697', '5c2f42277948043026b7a14692456828', '部门角色添加', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:role:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:29:57', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117748209905665', '5c2f42277948043026b7a14692456828', '部门角色编辑', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:role:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:30:26', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117804359053314', '5c2f42277948043026b7a14692456828', '部门角色删除', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:role:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:30:39', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592117990305132545', '5c2f42277948043026b7a14692456828', '部门角色批量删除', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:role:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:31:24', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592118053634928641', '5c2f42277948043026b7a14692456828', '部门角色用户授权', NULL, NULL, 0, NULL, NULL, 2, 'system:depart:role:userAdd', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:31:39', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592118192218927105', '1438782641187074050', '字典新增', NULL, NULL, 0, NULL, NULL, 2, 'system:dict:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:32:12', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592118254844080130', '1438782641187074050', '字典编辑', NULL, NULL, 0, NULL, NULL, 2, 'system:dict:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:32:27', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592118306983473154', '1438782641187074050', '字典删除', NULL, NULL, 0, NULL, NULL, 2, 'system:dict:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:32:39', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592118356778250241', '1438782641187074050', '字典批量删除', NULL, NULL, 0, NULL, NULL, 2, 'system:dict:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:32:51', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592118414990995457', '1438782641187074050', '字典导入', NULL, NULL, 0, NULL, NULL, 2, 'system:dict:importExcel', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:33:05', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592118604640645122', '1170592628746878978', '删除菜单', NULL, NULL, 0, NULL, NULL, 2, 'system:permission:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:33:50', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592118648315932674', '1170592628746878978', '批量删除菜单', NULL, NULL, 0, NULL, NULL, 2, 'system:permission:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:34:01', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592119001883176961', '1170592628746878978', '添加菜单权限数据', NULL, NULL, 0, NULL, NULL, 2, 'system:permission:addRule', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:35:25', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120052866707457', '1170592628746878978', '删除菜单权限数据', NULL, NULL, 0, NULL, NULL, 2, 'system:permission:deleteRule', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:39:35', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120222727630849', '45c966826eeff4c99b8f8ebfe74511fc', '保存部门授权', NULL, NULL, 0, NULL, NULL, 2, 'system:permission:saveDepart', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:40:16', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120224120850434', '190c2b43bec6a5f7a4194a85db67d96a', '查询全部角色不租户隔离', NULL, NULL, 0, NULL, NULL, 2, 'system:role:queryallNoByTenant', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 19:41:18', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120323667750914', '190c2b43bec6a5f7a4194a85db67d96a', '角色添加', NULL, NULL, 0, NULL, NULL, 2, 'system:role:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:40:40', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120323667750934', '1597419994965786625', '角色添加', NULL, NULL, 0, NULL, NULL, 2, 'system:role:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:40:40', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120372296511490', '190c2b43bec6a5f7a4194a85db67d96a', '角色编辑', NULL, NULL, 0, NULL, NULL, 2, 'system:role:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:40:52', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120372296522490', '1597419994965786625', '角色编辑', NULL, NULL, 0, NULL, NULL, 2, 'system:role:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:40:52', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120427007012865', '190c2b43bec6a5f7a4194a85db67d96a', '角色删除', NULL, NULL, 0, NULL, NULL, 2, 'system:role:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:41:05', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120427223412865', '1597419994965786625', '角色删除', NULL, NULL, 0, NULL, NULL, 2, 'system:role:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:41:05', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120484120850434', '190c2b43bec6a5f7a4194a85db67d96a', '角色批量删除', NULL, NULL, 0, NULL, NULL, 2, 'system:role:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:41:18', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120594695286785', '190c2b43bec6a5f7a4194a85db67d96a', '角色首页配置添加', NULL, NULL, 0, NULL, NULL, 2, 'system:roleindex:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:41:45', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592120649007329281', '190c2b43bec6a5f7a4194a85db67d96a', '角色首页配置编辑', NULL, NULL, 0, NULL, NULL, 2, 'system:roleindex:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:41:58', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1592135223910765570', '3f915b2769fc80648e92d04e84ca059d', '查询全部用户', NULL, NULL, 0, NULL, NULL, 2, 'system:user:listAll', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:20:22', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1593160905216663554', '1438782641187074050', '字典子项新增', NULL, NULL, 0, NULL, NULL, 2, 'system:dict:item:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-17 16:35:34', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1593160959633563650', '1438782641187074050', '字典子项编辑', NULL, NULL, 0, NULL, NULL, 2, 'system:dict:item:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-17 16:35:47', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1593161025790320641', '1438782641187074050', '字典子项删除', NULL, NULL, 0, NULL, NULL, 2, 'system:dict:item:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-17 16:36:03', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1593161089787011074', '1438782641187074050', '字典子项批量删除', NULL, NULL, 0, NULL, NULL, 2, 'system:dict:item:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-17 16:36:18', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1593185714482880514', '3f915b2769fc80648e92d04e84ca059d', '用户导出', NULL, NULL, 0, NULL, NULL, 2, 'system:user:export', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-17 18:14:09', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1594930803956920321', '1439398677984878593', '在线用户', '/system/onlineuser', 'system/onlineuser/OnlineUserList', 1, '', NULL, 1, NULL, '0', 12.00, 0, 'ant-design:aliwangwang-outlined', 1, 0, 0, 0, NULL, 'admin', '2022-11-22 13:48:31', 'admin', '2023-03-04 15:15:36', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1596141938193747970', 'd7d6e2e4e2934f2c9385a623fd98c6f3', '用户设置', '/system/usersetting', 'system/usersetting/UserSetting', 1, '', NULL, 1, NULL, '0', 12.00, 0, 'ant-design:setting-twotone', 0, 0, 1, 0, NULL, 'admin', '2022-11-25 22:01:08', 'admin', '2023-03-04 15:00:26', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1596335805278990338', '1596141938193747970', '账户设置用户编辑权限', NULL, NULL, 0, NULL, NULL, 2, 'system:user:setting:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-26 10:51:29', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1597419994965786625', '1674708136602542082', '租户角色', '/system/role/TenantRoleList', 'system/role/TenantRoleList', 1, 'tenant-role-list', NULL, 1, NULL, '0', 3.00, 0, 'ant-design:line-height-outlined', 0, 0, 0, 0, NULL, 'admin', '2022-11-29 10:39:40', 'admin', '2025-08-12 18:23:22', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('15c92115213910765570', '3f915b2769fc80648e92d04e84ca059d', '通过ID查询用户信息接口', NULL, NULL, 0, NULL, NULL, 2, 'system:user:queryById', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:20:22', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1600105607009162230', '1961253156897710081', '邀请用户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:invitation:user', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-06 20:31:20', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1600105607009165314', '1280350452934307841', '邀请用户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:invitation:user', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-06 20:31:20', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1600108123037913486', '1961253156897710081', '查询租户下用户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:user:list', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-06 20:41:20', 'admin', '2023-01-11 12:10:48', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1600108123037917186', '1280350452934307841', '通过租户id获取用户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:user:list', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-06 20:41:20', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1600129606082650113', '1280350452934307841', '租户请离', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:leave', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-06 22:06:42', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1600129606082650123', '119213522910765570', '租户请离', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:leave', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-06 22:06:42', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1609123240547344376', '1961253156897710081', '产品包分页列表查询', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:packList', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-31 17:44:11', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1609123240547344385', '1280350452934307841', '产品包分页列表查询', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:packList', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-31 17:44:11', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1609123437247619074', '1280350452934307841', '创建租户产品包', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:add:pack', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-31 17:44:58', 'admin', '2022-12-31 20:27:56', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1609164542165012482', '1280350452934307841', '编辑租户产品包', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:edit:pack', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-31 20:28:18', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1609164635442139138', '1280350452934307841', '批量删除租户产品包', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:delete:pack', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-12-31 20:28:41', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1611620416187969538', '1280350452934307841', '分页获取租户用户数据', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:tenantPageList', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-07 15:07:04', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1611620600003342337', '1280350452934307841', '通过用户id获取租户列表', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:getTenantListByUserId', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-07 15:07:48', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1611620654621569026', '1280350452934307841', '更新用户租户关系状态', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:updateUserTenantStatus', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-07 15:08:01', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1611620772498218641', '1280350452934307841', '查询租户列表', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:list', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 15:08:29', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1611620772498288641', '1280350452934307841', '注销租户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:cancelTenant', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-07 15:08:29', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1611650772498288641', '1280350452934307841', '删除租户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 15:08:29', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1612438989792034818', '1280350452934307841', '编辑租户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-07 15:08:29', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1613620712498288641', '1280350452934307841', '批量删除租户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 15:08:29', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1620261087828418562', '1280350452934307841', '获取租户删除的列表', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:recycleBinPageList', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-31 11:22:01', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1620305415648989186', '1280350452934307841', '彻底删除租户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:deleteTenantLogic', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-31 14:18:10', 'admin', '2023-01-31 14:19:51', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1620327825894981634', '1280350452934307841', '租户还原', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:revertTenantLogic', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-31 15:47:13', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1621620772498288641', '1280350452934307841', '添加租户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 15:08:29', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1660568280725127169', '1439533711676973057', '日志列表', NULL, NULL, 1, NULL, NULL, 2, 'system:log:list', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-05-22 16:48:25', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1660568368558047234', '1439533711676973057', '日志删除', NULL, NULL, 1, NULL, NULL, 2, 'system:log:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-05-22 16:48:46', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1660568426632380417', '1439533711676973057', '日志批量删除', NULL, NULL, 1, NULL, NULL, 2, 'system:log:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-05-22 16:48:59', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1674708136602542082', '', '我的租户', '/mytenant', 'layouts/RouteView', 1, '', NULL, 0, NULL, '0', 4.20, 0, 'ant-design:user-outlined', 0, 0, 1, 0, NULL, 'admin', '2023-06-30 17:15:09', 'admin', '2025-11-06 04:14:49', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1693195557097164801', '190c2b43bec6a5f7a4194a85db67d96a', '查询所有角色', NULL, NULL, 0, NULL, NULL, 2, 'system:role:list', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-08-20 17:37:34', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1697220712498288641', '1280350452934307841', '根据ids查询租户', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:queryList', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2023-01-11 15:08:29', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1698650926200352770', '1473927410093187073', '数据集解析SQL', NULL, NULL, 0, NULL, NULL, 2, 'drag:analysis:sql', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'jeecg', '2023-09-04 18:55:15', 'jeecg', '2023-09-05 20:36:51', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1699038961937113090', '1473927410093187073', '数据源添加', NULL, NULL, 0, NULL, NULL, 2, 'drag:datasource:saveOrUpate', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'jeecg', '2023-09-05 20:37:10', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1699039098474291201', '1473927410093187073', '数据源删除', NULL, NULL, 0, NULL, NULL, 2, 'drag:datasource:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'jeecg', '2023-09-05 20:37:42', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1699039192154071041', '1473927410093187073', '数据源批量删除', NULL, NULL, 0, NULL, NULL, 2, 'drag:datasource:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'jeecg', '2023-09-05 20:38:05', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1701475606988812289', '1473927410093187073', '数据源连接', NULL, NULL, 0, NULL, NULL, 2, 'drag:datasource:testConnection', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'jeecg', '2023-09-12 13:59:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1701575168519839746', 'd7d6e2e4e2934f2c9385a623fd98c6f3', '白名单管理', '/system/tableWhiteList', 'system/tableWhiteList/SysTableWhiteListList', 1, '', NULL, 1, NULL, '0', 4.00, 0, 'ant-design:table-outlined', 0, 0, 0, 0, NULL, 'admin', '2023-09-12 20:35:09', 'jeecg', '2024-06-13 11:38:28', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1750128461040648193', '1170592628746878978', '设置默认首页', NULL, NULL, 0, NULL, NULL, 2, 'system:permission:setDefIndex', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2024-01-24 20:08:35', NULL, NULL, 0, NULL, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1800372628805861377', '1701575168519839746', '列表权限', NULL, NULL, 0, NULL, NULL, 2, 'system:tableWhite:list', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, '15931993294', '2024-06-11 11:40:59', NULL, NULL, 0, NULL, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1800372727493640194', '1701575168519839746', '添加权限', NULL, NULL, 0, NULL, NULL, 2, 'system:tableWhite:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, '15931993294', '2024-06-11 11:41:22', NULL, NULL, 0, NULL, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1800372811518132225', '1701575168519839746', '修改权限', NULL, NULL, 0, NULL, NULL, 2, 'system:tableWhite:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, '15931993294', '2024-06-11 11:41:42', NULL, NULL, 0, NULL, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1800372906330374146', '1701575168519839746', '删除权限', NULL, NULL, 0, NULL, NULL, 2, 'system:tableWhite:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, '15931993294', '2024-06-11 11:42:05', NULL, NULL, 0, NULL, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1800373633509441537', '1701575168519839746', '批量删除', NULL, NULL, 0, NULL, NULL, 2, 'system:tableWhite:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, '15931993294', '2024-06-11 11:44:58', NULL, NULL, 0, NULL, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1800373733220630530', '1701575168519839746', '通过id查询', NULL, NULL, 0, NULL, NULL, 2, 'system:tableWhite:queryById', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, '15931993294', '2024-06-11 11:45:22', NULL, NULL, 0, NULL, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1808098125316870145', '3f915b2769fc80648e92d04e84ca059d', 'app端编辑用户', NULL, NULL, 0, NULL, NULL, 2, 'system:user:app:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2024-07-02 19:19:21', NULL, NULL, 0, NULL, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1810652607946940417', '1438782641187074050', '批量彻底删除', NULL, NULL, 0, NULL, NULL, 2, 'system:dict:deleteRecycleBin', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, '15931993294', '2024-07-09 20:29:57', '15931993294', '2024-07-09 20:30:39', 0, NULL, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853001', '', '业务中心', '/learning', 'layouts/default/index', 1, 'Learning', '/learning/place-order', 0, NULL, '1', 2.00, 0, 'ant-design:highlight-outlined', 0, 0, 0, 0, 'Learning订单管理系统', 'admin', '2025-11-05 00:02:40', 'admin', '2025-11-12 16:50:31', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853001001', '1853001', '系统管理员', NULL, NULL, 1, NULL, NULL, 2, 'learning:admin', '0', 99.00, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, '2025-12-17 02:16:19', NULL, NULL, 0, 0, '1', NULL);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853002', '1853001', '订单管理', '/learning/order', 'learning/order/index', 1, 'OrderManagement', NULL, 1, NULL, '1', 2.00, 0, 'ant-design:inbox-outlined', 0, 1, 0, 0, '订单管理页面', 'admin', '2025-11-05 00:02:40', 'admin', '2025-11-06 04:20:36', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853002001', '1853002', '查询', NULL, NULL, 1, NULL, NULL, 2, 'learning:order:query', '1', 1.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-11-05 20:47:06', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853002002', '1853002', '新增', NULL, NULL, 1, NULL, NULL, 2, 'learning:order:add', '1', 2.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-11-05 20:47:06', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853002003', '1853002', '编辑', NULL, NULL, 1, NULL, NULL, 2, 'learning:order:edit', '1', 3.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-11-05 20:47:06', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853002004', '1853002', '删除', NULL, NULL, 1, NULL, NULL, 2, 'learning:order:delete', '1', 4.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-11-05 20:47:06', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853002005', '1853002', '管理员操作', NULL, NULL, 1, NULL, NULL, 2, 'learning:order:admin', '0', 5.00, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, '2025-12-17 02:16:19', NULL, NULL, 0, 0, '1', NULL);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853003', '1853001', '商品管理', '/learning/course', 'learning/course/index', 1, 'CourseManagement', NULL, 1, NULL, '1', 3.00, 0, 'ant-design:read-outlined', 0, 1, 0, 0, '课程管理页面', 'admin', '2025-11-05 00:02:40', 'admin', '2025-11-13 18:12:53', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853003001', '1853003', '查询', NULL, NULL, 1, NULL, NULL, 2, 'learning:course:query', '1', 1.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-11-05 20:47:06', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853003002', '1853003', '新增', NULL, NULL, 1, NULL, NULL, 2, 'learning:course:add', '1', 2.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-11-05 20:47:06', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853003003', '1853003', '编辑', NULL, NULL, 1, NULL, NULL, 2, 'learning:course:edit', '1', 3.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-11-05 20:47:06', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853003004', '1853003', '删除', NULL, NULL, 1, NULL, NULL, 2, 'learning:course:delete', '1', 4.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-11-05 20:47:06', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853004', 'menu_finance_center', '财务管理', '/learning/finance', 'learning/finance/index', 1, 'FinanceManagement', NULL, 1, NULL, '1', 1.00, 0, 'ant-design:money-collect-outlined', 0, 1, 0, 0, '财务管理页面', 'admin', '2025-11-05 00:02:40', 'admin', '2025-11-06 04:21:21', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853004001', '1853004', '查询', NULL, NULL, 1, NULL, NULL, 2, 'learning:finance:query', '1', 1.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-11-05 20:47:06', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853004002', '1853004', '管理员操作', NULL, NULL, 1, NULL, NULL, 2, 'learning:finance:admin', '0', 2.00, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, '2025-12-17 02:16:19', NULL, NULL, 0, 0, '1', NULL);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853005', 'menu_operation', '平台配置', '/learning/platform-config', 'learning/platformConfig/index', 1, 'PlatformConfigManagement', NULL, 1, NULL, '1', 3.00, 0, 'ant-design:setting-outlined', 0, 1, 0, 0, '平台配置管理页面', 'admin', '2025-11-05 20:31:27', 'admin', '2025-11-06 04:21:33', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853005001', '1853005', '查询', NULL, NULL, 0, NULL, NULL, 2, 'learning:platform:query', '1', 1.00, 0, NULL, 1, 0, 0, 0, '查询平台配置', 'admin', '2025-11-05 20:31:27', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853005002', '1853005', '新增', NULL, NULL, 0, NULL, NULL, 2, 'learning:platform:add', '1', 2.00, 0, NULL, 1, 0, 0, 0, '新增平台配置', 'admin', '2025-11-05 20:31:27', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853005003', '1853005', '编辑', NULL, NULL, 0, NULL, NULL, 2, 'learning:platform:edit', '1', 3.00, 0, NULL, 1, 0, 0, 0, '编辑平台配置', 'admin', '2025-11-05 20:31:27', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853005004', '1853005', '删除', NULL, NULL, 0, NULL, NULL, 2, 'learning:platform:delete', '1', 4.00, 0, NULL, 1, 0, 0, 0, '删除平台配置', 'admin', '2025-11-05 20:31:27', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853006', '1853001', '查课下单', '/learning/place-order', 'learning/placeOrder/index', 1, 'PlaceOrder', NULL, 1, NULL, '1', 1.00, 0, 'ant-design:reconciliation-outlined', 0, 1, 0, 0, '查课下单页面', 'admin', '2025-11-07 14:46:41', 'admin', '2025-11-07 14:58:35', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853006001', '1853006', '查询课程', NULL, NULL, 0, NULL, NULL, 2, 'learning:placeorder:query', '1', 1.00, 0, NULL, 1, 0, 0, 0, '查询课程信息', 'admin', '2025-11-07 14:46:41', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1853006002', '1853006', '创建订单', NULL, NULL, 0, NULL, NULL, 2, 'learning:placeorder:create', '1', 2.00, 0, NULL, 1, 0, 0, 0, '创建订单', 'admin', '2025-11-07 14:46:41', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1876220177009315842', '1473927410093187073', '表单设计页面查询', NULL, NULL, 0, NULL, NULL, 2, 'drag:design:getTotalData', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-01-06 18:52:03', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1887447660072292354', '1280350452934307841', '初始化套餐包', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:syncDefaultPack', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'jeecg', '2025-02-06 18:26:04', 'jeecg', '2025-02-06 18:26:53', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1907441271556497409', '1473927410093187073', '清空回收站', NULL, NULL, 0, NULL, NULL, 2, 'onl:drag:clear:recovery', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-04-02 22:33:32', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('190c2b43bec6a5f7a4194a85db67d96a', 'd7d6e2e4e2934f2c9385a623fd98c6f3', '角色管理', '/system/role', 'system/role/index', 1, NULL, NULL, 1, NULL, NULL, 2.00, 0, 'ant-design:solution', 0, 1, 0, NULL, NULL, NULL, '2018-12-25 20:34:38', 'admin', '2021-09-17 15:58:00', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1939572818833301506', 'd7d6e2e4e2934f2c9385a623fd98c6f3', '首页配置', '/system/homeConfig', 'system/homeConfig/index', 1, '', NULL, 1, NULL, '0', 1.00, 0, 'ant-design:appstore-outlined', 0, 0, 0, 0, NULL, 'admin', '2025-06-30 14:32:50', 'admin', '2025-07-01 20:13:22', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1941349246536998913', '1939572818833301506', '首页配置-添加', NULL, NULL, 0, NULL, NULL, 2, 'system:roleindex:add', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-07-05 12:11:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1941349335431077889', '1939572818833301506', '首页配置-编辑', NULL, NULL, 0, NULL, NULL, 2, 'system:roleindex:edit', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-07-05 12:12:05', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1941349462887587842', '1939572818833301506', '首页配置-删除', NULL, NULL, 0, NULL, NULL, 2, 'system:roleindex:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-07-05 12:12:35', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1941349550087168001', '1939572818833301506', '首页配置-批量删除', NULL, NULL, 0, NULL, NULL, 2, 'system:roleindex:deleteBatch', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-07-05 12:12:56', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1947833384695164929', '1629109281748291586', '第三方配置删除', NULL, NULL, 0, NULL, NULL, 2, 'system:third:config:delete', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-07-23 09:37:23', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1960994076329316353', '119213522910765570', '添加一个用户和多个套餐关系', NULL, NULL, 0, NULL, NULL, 2, 'system:tenant:addPacksUser', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-08-28 17:13:16', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1961009998209257473', '1674708136602542082', '租户部门', '/depart/TenantDepartList', 'system/depart/TenantDepartList', 1, '', NULL, 1, NULL, '0', 3.30, 0, 'ant-design:apartment-outlined', 0, 0, 0, 0, NULL, 'admin', '2025-08-28 18:16:32', 'admin', '2025-08-29 10:20:25', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1961253156897710081', '1674708136602542082', '租户套餐', '/pack/TenantCurrentPackList', 'system/tenant/pack/TenantCurrentPackList', 1, '', NULL, 1, NULL, '0', 3.40, 0, 'ant-design:read-filled', 0, 0, 0, 0, NULL, 'admin', '2025-08-29 10:22:46', 'admin', '2025-08-29 10:24:46', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1963133393868722178', '1674708136602542082', '我的租户', '/my/MyTenantDetail', 'system/tenant/my/MyTenantDetail', 1, '', NULL, 1, NULL, '0', 0.00, 0, 'ant-design:user-outlined', 1, 0, 0, 0, NULL, 'admin', '2025-09-03 14:54:09', 'admin', '2025-09-13 17:16:57', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1988583175138287618', '1853004', '用户充值', NULL, NULL, 0, NULL, NULL, 2, 'learning:finance:recharge', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2025-11-12 20:22:30', 'admin', '2025-11-12 20:22:45', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1997148797176389634', 'menu_finance_center', '支付管理', '/learning/payment', 'learning/payment/index', 1, '', NULL, 1, NULL, '0', 2.00, 0, 'ant-design:money-collect-outlined', 1, 0, 0, 0, NULL, 'admin', '2025-12-06 11:39:13', 'admin', '2025-12-12 02:13:47', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1999079554806845441', 'menu_operation', '工单管理', '/learning/ticket', 'learning/ticket/index', 1, 'Ticket', NULL, 1, NULL, '0', 1.00, 0, 'ant-design:folder-outlined', 1, 1, 0, 0, NULL, 'admin', '2025-12-11 19:31:22', NULL, NULL, 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1a0811914300741f4e11838ff37a1d3a', '3f915b2769fc80648e92d04e84ca059d', '手机号禁用', '', '', 0, NULL, NULL, 2, 'user:form:phone', '2', 1.00, 0, NULL, 1, NULL, 0, NULL, NULL, 'admin', '2019-05-11 17:19:30', 'admin', '2019-05-11 18:00:22', 0, 0, '1', NULL);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('1d592115213910765570', '3f915b2769fc80648e92d04e84ca059d', '通过ID查询用户拥有的角色', NULL, NULL, 0, NULL, NULL, 2, 'system:user:queryUserRole', '1', NULL, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2022-11-14 19:20:22', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('3f915b2769fc80648e92d04e84ca059d', 'd7d6e2e4e2934f2c9385a623fd98c6f3', '用户管理', '/system/user', 'system/user/index', 1, NULL, NULL, 1, NULL, NULL, 1.00, 0, 'ant-design:user', 0, 1, 0, NULL, NULL, NULL, '2018-12-25 20:34:38', 'sunjianlei', '2021-05-08 09:57:31', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('45c966826eeff4c99b8f8ebfe74511fc', 'd7d6e2e4e2934f2c9385a623fd98c6f3', '部门管理', '/system/depart', 'system/depart/index', 1, NULL, NULL, 1, NULL, NULL, 3.00, 0, 'ant-design:team', 0, 0, 1, 0, NULL, 'admin', '2019-01-29 18:47:40', 'admin', '2025-12-27 17:40:37', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a2f4b88d24811f0ac2a5254006b23b9', 'LEARNING_PARENT_ID', '暂存课程管理', '/learning/course-staging', 'learning/courseStaging/index', 1, 'CourseStagingManagement', NULL, 1, NULL, '1', 5.00, 0, 'ant-design:database-outlined', 0, 1, 0, 0, '课程同步暂存表管理，支持审核、编辑、批量入库等操作', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a4c0169d24811f0ac2a5254006b23b9', '5a2f4b88d24811f0ac2a5254006b23b9', '查询', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:list', '1', 1.00, NULL, NULL, 1, 0, 0, NULL, '查询暂存课程列表', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a4c0847d24811f0ac2a5254006b23b9', '5a2f4b88d24811f0ac2a5254006b23b9', '编辑', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:edit', '1', 2.00, NULL, NULL, 1, 0, 0, NULL, '编辑暂存课程', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a4c0a3bd24811f0ac2a5254006b23b9', '5a2f4b88d24811f0ac2a5254006b23b9', '审核', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:approve', '1', 3.00, NULL, NULL, 1, 0, 0, NULL, '审核暂存课程', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a4c0b98d24811f0ac2a5254006b23b9', '5a2f4b88d24811f0ac2a5254006b23b9', '入库', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:import', '1', 4.00, NULL, NULL, 1, 0, 0, NULL, '暂存课程入库到商品表', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a4c0ce7d24811f0ac2a5254006b23b9', '5a2f4b88d24811f0ac2a5254006b23b9', '更新已入库', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:update', '1', 5.00, NULL, NULL, 1, 0, 0, NULL, '批量更新已入库的课程', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a4c0e13d24811f0ac2a5254006b23b9', '5a2f4b88d24811f0ac2a5254006b23b9', '处理下架', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:handle-offline', '1', 6.00, NULL, NULL, 1, 0, 0, NULL, '处理平台下架的课程', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a57c04ed24811f0ac2a5254006b23b9', 'LEARNING_PARENT_ID', '同步规则配置', '/learning/sync-rule', 'learning/syncRule/index', 1, 'SyncRuleManagement', NULL, 1, NULL, '1', 6.00, 0, 'ant-design:control-outlined', 0, 1, 0, 0, '配置和管理各平台的课程同步规则', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a6bb384d24811f0ac2a5254006b23b9', '5a57c04ed24811f0ac2a5254006b23b9', '查询', NULL, NULL, 1, NULL, NULL, 2, 'learning:sync-rule:list', '1', 1.00, NULL, NULL, 1, 0, 0, NULL, '查询同步规则列表', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a6bb8eed24811f0ac2a5254006b23b9', '5a57c04ed24811f0ac2a5254006b23b9', '新增', NULL, NULL, 1, NULL, NULL, 2, 'learning:sync-rule:add', '1', 2.00, NULL, NULL, 1, 0, 0, NULL, '新增同步规则', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a6bba69d24811f0ac2a5254006b23b9', '5a57c04ed24811f0ac2a5254006b23b9', '编辑', NULL, NULL, 1, NULL, NULL, 2, 'learning:sync-rule:edit', '1', 3.00, NULL, NULL, 1, 0, 0, NULL, '编辑同步规则', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5a6bbba4d24811f0ac2a5254006b23b9', '5a57c04ed24811f0ac2a5254006b23b9', '删除', NULL, NULL, 1, NULL, NULL, 2, 'learning:sync-rule:delete', '1', 4.00, NULL, NULL, 1, 0, 0, NULL, '删除同步规则', 'admin', '2025-12-06 10:07:44', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('5c2f42277948043026b7a14692456828', 'd7d6e2e4e2934f2c9385a623fd98c6f3', '我的部门', '/system/depart-user', 'system/departUser/index', 1, NULL, NULL, 1, NULL, NULL, 3.00, 0, 'ant-design:home-outlined', 0, 0, 1, 0, NULL, 'admin', '2019-04-17 15:12:24', 'admin', '2025-12-27 17:40:25', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('9502685863ab87f0ad1134142788a385', '1438108176273760258', '首页', '/dashboard/analysis', 'dashboard/Analysis', 1, NULL, NULL, 1, NULL, NULL, 1.00, 0, 'ant-design:qrcode-outlined', 1, 1, 0, 0, NULL, NULL, '2018-12-25 20:34:38', 'jeecg', '2024-06-18 23:09:37', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be0dc86ed24811f0ac2a5254006b23b9', 'LEARNING_PARENT_ID', '暂存课程管理', '/learning/course-staging', 'learning/courseStaging/index', 1, 'CourseStagingManagement', NULL, 1, NULL, '1', 5.00, 0, 'ant-design:database-outlined', 0, 1, 0, 0, '课程同步暂存表管理，支持审核、编辑、批量入库等操作', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be203e04d24811f0ac2a5254006b23b9', 'be0dc86ed24811f0ac2a5254006b23b9', '查询', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:list', '1', 1.00, NULL, NULL, 1, 0, 0, NULL, '查询暂存课程列表', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be20441dd24811f0ac2a5254006b23b9', 'be0dc86ed24811f0ac2a5254006b23b9', '编辑', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:edit', '1', 2.00, NULL, NULL, 1, 0, 0, NULL, '编辑暂存课程', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be2045d6d24811f0ac2a5254006b23b9', 'be0dc86ed24811f0ac2a5254006b23b9', '审核', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:approve', '1', 3.00, NULL, NULL, 1, 0, 0, NULL, '审核暂存课程', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be204719d24811f0ac2a5254006b23b9', 'be0dc86ed24811f0ac2a5254006b23b9', '入库', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:import', '1', 4.00, NULL, NULL, 1, 0, 0, NULL, '暂存课程入库到商品表', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be204859d24811f0ac2a5254006b23b9', 'be0dc86ed24811f0ac2a5254006b23b9', '更新已入库', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:update', '1', 5.00, NULL, NULL, 1, 0, 0, NULL, '批量更新已入库的课程', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be204a83d24811f0ac2a5254006b23b9', 'be0dc86ed24811f0ac2a5254006b23b9', '处理下架', NULL, NULL, 1, NULL, NULL, 2, 'learning:staging:handle-offline', '1', 6.00, NULL, NULL, 1, 0, 0, NULL, '处理平台下架的课程', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be27f66bd24811f0ac2a5254006b23b9', 'LEARNING_PARENT_ID', '同步规则配置', '/learning/sync-rule', 'learning/syncRule/index', 1, 'SyncRuleManagement', NULL, 1, NULL, '1', 6.00, 0, 'ant-design:control-outlined', 0, 1, 0, 0, '配置和管理各平台的课程同步规则', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be36b49dd24811f0ac2a5254006b23b9', 'be27f66bd24811f0ac2a5254006b23b9', '查询', NULL, NULL, 1, NULL, NULL, 2, 'learning:sync-rule:list', '1', 1.00, NULL, NULL, 1, 0, 0, NULL, '查询同步规则列表', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be36baffd24811f0ac2a5254006b23b9', 'be27f66bd24811f0ac2a5254006b23b9', '新增', NULL, NULL, 1, NULL, NULL, 2, 'learning:sync-rule:add', '1', 2.00, NULL, NULL, 1, 0, 0, NULL, '新增同步规则', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be36bca2d24811f0ac2a5254006b23b9', 'be27f66bd24811f0ac2a5254006b23b9', '编辑', NULL, NULL, 1, NULL, NULL, 2, 'learning:sync-rule:edit', '1', 3.00, NULL, NULL, 1, 0, 0, NULL, '编辑同步规则', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('be38b0e5d24811f0ac2a5254006b23b9', 'be27f66bd24811f0ac2a5254006b23b9', '删除', NULL, NULL, 1, NULL, NULL, 2, 'learning:sync-rule:delete', '1', 4.00, NULL, NULL, 1, 0, 0, NULL, '删除同步规则', 'admin', '2025-12-06 10:10:31', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('d7d6e2e4e2934f2c9385a623fd98c6f3', '', '系统管理', '/isystem', 'layouts/RouteView', 1, NULL, NULL, 0, NULL, NULL, 4.00, 0, 'ant-design:setting', 0, 0, 0, 0, NULL, NULL, '2018-12-25 20:34:38', 'admin', '2025-06-25 14:24:07', 0, 0, NULL, 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('f15543b0263cf6c5fac85afdd3eba3f2', '3f915b2769fc80648e92d04e84ca059d', '用户导入', '', NULL, 0, NULL, NULL, 2, 'system:user:import', '1', 1.00, 0, NULL, 1, 0, 0, 0, NULL, 'admin', '2019-05-13 19:15:27', 'admin', '2022-06-30 15:05:12', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('fff54234d35911f08076525400e87d0c', 'menu_agent_center', '代理中心', '/learning/agent', 'learning/agent/index', 1, NULL, NULL, 1, NULL, '1', 1.00, 0, 'ant-design:team-outlined', 1, 0, 0, 0, '代理信息、邀请码、返利记录等', 'admin', '2025-12-07 18:46:34', NULL, NULL, 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('menu_agent_center', '', '代理中心', '/agent', 'layouts/RouteView', 1, NULL, NULL, 0, NULL, '0', 3.00, 0, 'ant-design:bold-outlined', 0, 0, 0, 0, NULL, 'admin', '2025-12-27 17:28:58', 'admin', '2025-12-27 17:59:09', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('menu_finance_center', '', '财务中心', '/finance', 'layouts/RouteView', 1, NULL, NULL, 0, NULL, '0', 4.00, 0, 'ant-design:pie-chart-outlined', 0, 0, 0, 0, NULL, 'admin', '2025-12-27 17:28:58', 'admin', '2025-12-27 17:59:26', 0, 0, '1', 0);
INSERT INTO `sys_permission` (`id`, `parent_id`, `name`, `url`, `component`, `is_route`, `component_name`, `redirect`, `menu_type`, `perms`, `perms_type`, `sort_no`, `always_show`, `icon`, `is_leaf`, `keep_alive`, `hidden`, `hide_tab`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `rule_flag`, `status`, `internal_or_external`) VALUES ('menu_operation', '', '运营管理', '/operation', 'layouts/RouteView', 1, NULL, NULL, 0, NULL, '0', 5.00, 0, 'ant-design:smile-outlined', 0, 0, 0, 0, NULL, 'admin', '2025-12-27 17:28:58', 'admin', '2025-12-27 17:59:47', 0, 0, '1', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键id',
  `role_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '角色名称',
  `role_code` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '角色编码',
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '描述',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `tenant_id` int DEFAULT '0' COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq_sys_role_role_code` (`role_code`) USING BTREE,
  KEY `idx_sysrole_tenant_id` (`tenant_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='角色表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` (`id`, `role_name`, `role_code`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `tenant_id`) VALUES ('092e7af7e18e11f08076525400e87d0c', '站长', 'tenant_admin', '分站管理员，管理本站用户、订单和财务', 'system', '2025-12-25 20:34:20', NULL, NULL, 0);
INSERT INTO `sys_role` (`id`, `role_name`, `role_code`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `tenant_id`) VALUES ('1988235440530857986', '用户', 'user', NULL, 'admin', '2025-11-11 21:20:43', NULL, NULL, 0);
INSERT INTO `sys_role` (`id`, `role_name`, `role_code`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `tenant_id`) VALUES ('2006015005280505857', '超级开发', 'super_admin', '开发管理员', 'admin', '2025-12-30 22:50:22', NULL, NULL, 0);
INSERT INTO `sys_role` (`id`, `role_name`, `role_code`, `description`, `create_by`, `create_time`, `update_by`, `update_time`, `tenant_id`) VALUES ('f6817f48af4fb3af11b9e8bf182f618b', '管理员', 'admin', NULL, 'admin', '2025-11-04 19:47:01', 'admin', '2025-11-04 19:47:01', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_role_index
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_index`;
CREATE TABLE `sys_role_index` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '角色编码',
  `url` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '组件',
  `is_route` tinyint(1) DEFAULT '1' COMMENT '是否路由菜单: 0:不是  1:是（默认值1）',
  `priority` int DEFAULT '0' COMMENT '优先级',
  `status` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '状态0:无效 1:有效',
  `create_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人登录名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人登录名称',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  `sys_org_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所属部门',
  `relation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联关系(ROLE:角色 USER:用户)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sri_role_code` (`role_code`) USING BTREE,
  KEY `idx_sri_status` (`status`) USING BTREE,
  KEY `idx_sri_priority` (`priority`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色首页表';

-- ----------------------------
-- Records of sys_role_index
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_index` (`id`, `role_code`, `url`, `component`, `is_route`, `priority`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `sys_org_code`, `relation_type`) VALUES ('1803082647166652418', 'DEF_INDEX_ALL', '/dashboard/analysis', 'dashboard/Analysis', 1, 0, '1', 'jeecg', '2024-06-18 23:09:37', 'admin', '2025-11-12 20:05:33', 'A02A01', 'DEFAULT');
COMMIT;

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键ID',
  `role_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '角色id',
  `permission_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '权限id',
  `data_rule_ids` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '数据权限ids',
  `operate_date` datetime DEFAULT NULL COMMENT '操作时间',
  `operate_ip` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '操作ip',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_srp_role_per_id` (`role_id`,`permission_id`) USING BTREE,
  KEY `idx_srp_role_id` (`role_id`) USING BTREE,
  KEY `idx_srp_permission_id` (`permission_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='角色权限表';

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('00b0748f04d3ea52c8cfa179c1c9d384', '52b0cf022ac4187b2a70dfa4f8b2d940', 'd7d6e2e4e2934f2c9385a623fd98c6f3', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('0d9d14bc66e9d5e99b0280095fdc8587', 'ee8626f80f7c2619917b6236f3a7f02b', '277bfabef7d76e89b33062b16a9a5020', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('0dec36b68c234767cd35466efef3b941', 'ee8626f80f7c2619917b6236f3a7f02b', '54dd5457a3190740005c1bfec55b1c34', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('115a6673ae6c0816d3f60de221520274', '21c5a3187763729408b40afb0d0fdfa8', '63b551e81c5956d5c861593d366d8c57', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1232123957949304833', 'ee8626f80f7c2619917b6236f3a7f02b', 'f0675b52d89100ee88472b6800754a08', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1232123957978664962', 'ee8626f80f7c2619917b6236f3a7f02b', '1232123780958064642', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1232123957978664963', 'ee8626f80f7c2619917b6236f3a7f02b', '020b06793e4de2eee0007f603000c769', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1232123957987053570', 'ee8626f80f7c2619917b6236f3a7f02b', '2aeddae571695cd6380f6d6d334d6e7d', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1232125488694104066', 'ee8626f80f7c2619917b6236f3a7f02b', 'e41b69c57a941a3bbcce45032fe57605', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1260929736852488194', 'ee8626f80f7c2619917b6236f3a7f02b', '1260929666434318338', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1260931414095937537', 'ee8626f80f7c2619917b6236f3a7f02b', '1260931366557696001', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1281494164924653569', 'f6817f48af4fb3af11b9e8bf182f618b', '1280350452934307841', NULL, '2020-07-10 15:43:13', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775947751425', 'ee8626f80f7c2619917b6236f3a7f02b', '1352200630711652354', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775956140034', 'ee8626f80f7c2619917b6236f3a7f02b', '1205097455226462210', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775956140035', 'ee8626f80f7c2619917b6236f3a7f02b', '1335960713267093506', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775964528642', 'ee8626f80f7c2619917b6236f3a7f02b', '1205098241075453953', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775964528643', 'ee8626f80f7c2619917b6236f3a7f02b', '1205306106780364802', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775972917250', 'ee8626f80f7c2619917b6236f3a7f02b', '109c78a583d4693ce2f16551b7786786', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775972917251', 'ee8626f80f7c2619917b6236f3a7f02b', '1192318987661234177', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775972917252', 'ee8626f80f7c2619917b6236f3a7f02b', '1224641973866467330', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775977111554', 'ee8626f80f7c2619917b6236f3a7f02b', '1229674163694841857', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775977111555', 'ee8626f80f7c2619917b6236f3a7f02b', '1209731624921534465', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775977111556', 'ee8626f80f7c2619917b6236f3a7f02b', '1304032910990495745', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775977111559', 'ee8626f80f7c2619917b6236f3a7f02b', '1174506953255182338', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775985500162', 'ee8626f80f7c2619917b6236f3a7f02b', '1174590283938041857', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775985500163', 'ee8626f80f7c2619917b6236f3a7f02b', 'ebb9d82ea16ad864071158e0c449d186', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775985500164', 'ee8626f80f7c2619917b6236f3a7f02b', '1404684556047024130', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775985500165', 'ee8626f80f7c2619917b6236f3a7f02b', '1265162119913824258', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775989694465', 'ee8626f80f7c2619917b6236f3a7f02b', '841057b8a1bef8f6b4b20f9a618a7fa6', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775989694466', 'ee8626f80f7c2619917b6236f3a7f02b', '700b7f95165c46cc7a78bf227aa8fed3', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775989694467', 'ee8626f80f7c2619917b6236f3a7f02b', '8d1ebd663688965f1fd86a2f0ead3416', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775989694468', 'ee8626f80f7c2619917b6236f3a7f02b', '024f1fd1283dc632458976463d8984e1', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775989694469', 'ee8626f80f7c2619917b6236f3a7f02b', '8b3bff2eee6f1939147f5c68292a1642', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775998083074', 'ee8626f80f7c2619917b6236f3a7f02b', 'd07a2c87a451434c99ab06296727ec4f', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775998083075', 'ee8626f80f7c2619917b6236f3a7f02b', 'fc810a2267dd183e4ef7c71cc60f4670', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775998083076', 'ee8626f80f7c2619917b6236f3a7f02b', '97c8629abc7848eccdb6d77c24bb3ebb', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775998083077', 'ee8626f80f7c2619917b6236f3a7f02b', '1287715272999944193', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184775998083078', 'ee8626f80f7c2619917b6236f3a7f02b', '1287715783966834689', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776006471682', 'ee8626f80f7c2619917b6236f3a7f02b', '1287716451494510593', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776006471683', 'ee8626f80f7c2619917b6236f3a7f02b', '1287718919049691137', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776006471684', 'ee8626f80f7c2619917b6236f3a7f02b', '1287718938179911682', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776006471685', 'ee8626f80f7c2619917b6236f3a7f02b', '1287718956957810689', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776006471686', 'ee8626f80f7c2619917b6236f3a7f02b', '1166535831146504193', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776006471687', 'ee8626f80f7c2619917b6236f3a7f02b', '9a90363f216a6a08f32eecb3f0bf12a3', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776014860289', 'ee8626f80f7c2619917b6236f3a7f02b', '4356a1a67b564f0988a484f5531fd4d9', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776014860290', 'ee8626f80f7c2619917b6236f3a7f02b', '655563cd64b75dcf52ef7bcdd4836953', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776014860291', 'ee8626f80f7c2619917b6236f3a7f02b', '1365187528377102337', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776014860292', 'ee8626f80f7c2619917b6236f3a7f02b', '6ad53fd1b220989a8b71ff482d683a5a', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776014860293', 'ee8626f80f7c2619917b6236f3a7f02b', '7960961b0063228937da5fa8dd73d371', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776014860294', 'ee8626f80f7c2619917b6236f3a7f02b', '1387612436586065922', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776014860295', 'ee8626f80f7c2619917b6236f3a7f02b', '043780fa095ff1b2bec4dc406d76f023', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776023248897', 'ee8626f80f7c2619917b6236f3a7f02b', '0620e402857b8c5b605e1ad9f4b89350', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776023248898', 'ee8626f80f7c2619917b6236f3a7f02b', 'c431130c0bc0ec71b0a5be37747bb36a', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1427184776023248899', 'ee8626f80f7c2619917b6236f3a7f02b', 'e1979bb53e9ea51cecc74d86fd9d2f64', NULL, '2021-08-16 16:25:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988789567490', '1501570619841810433', '1438108176273760258', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988802150402', '1501570619841810433', '1438108176814825473', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988810539010', '1501570619841810433', '9502685863ab87f0ad1134142788a385', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988814733313', '1501570619841810433', 'd7d6e2e4e2934f2c9385a623fd98c6f3', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988814733314', '1501570619841810433', '3f915b2769fc80648e92d04e84ca059d', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988823121922', '1501570619841810433', '1214376304951664642', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988823121923', '1501570619841810433', '1214462306546319362', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988831510529', '1501570619841810433', '1a0811914300741f4e11838ff37a1d3a', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988831510530', '1501570619841810433', '190c2b43bec6a5f7a4194a85db67d96a', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988831510531', '1501570619841810433', '1170592628746878978', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988831510532', '1501570619841810433', '45c966826eeff4c99b8f8ebfe74511fc', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988831510534', '1501570619841810433', '1438782851980210178', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988839899138', '1501570619841810433', '1438782530717495298', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988839899139', '1501570619841810433', '1438782641187074050', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988844093443', '1501570619841810433', '1280350452934307841', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988844093444', '1501570619841810433', '1439398677984878593', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988844093445', '1501570619841810433', '1439399179791409153', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988844093446', '1501570619841810433', '1439488251473993730', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988844093447', '1501570619841810433', '1438469604861403137', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988856676354', '1501570619841810433', '1439531077792473089', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988856676355', '1501570619841810433', '1439533711676973057', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988860870657', '1501570619841810433', '1439784356766064642', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988860870658', '1501570619841810433', '1439797053314342913', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988860870659', '1501570619841810433', '1439839507094740994', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501570988869259265', '1501570619841810433', '1439842640030113793', NULL, '2022-03-09 22:49:56', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501576319410212868', '1501570619841810433', '1449995470942593026', NULL, '2022-03-09 23:11:07', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1501576328700596228', '1501570619841810433', '1449995470942593026', NULL, '2022-03-09 23:11:09', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1580835941080784898', '1501570619841810433', '1580835899477483522', NULL, '2022-10-14 16:20:34', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1580878701653643267', '1501570619841810433', '1580878668472504321', NULL, '2022-10-14 19:10:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1580878704866480129', '1501570619841810433', '1580878668472504321', NULL, '2022-10-14 19:10:29', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1587064040495644677', '1501570619841810433', '1452508868884353026', NULL, '2022-10-31 20:48:48', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444602613761', '1501570619841810433', '1588513553652436993', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444602613762', '1501570619841810433', '1592114574275211265', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444602613763', '1501570619841810433', '1592114652566089729', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444602613765', '1501570619841810433', '1592114772665790465', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444602613766', '1501570619841810433', '1592114823467200514', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444602613767', '1501570619841810433', '1592114893302362114', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444602613768', '1501570619841810433', '1592114955650691074', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722625', '1501570619841810433', '1592115070432014338', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722626', '1501570619841810433', '1592115115361398786', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722627', '1501570619841810433', '1592115162379546625', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722628', '1501570619841810433', '1592115213910765570', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722631', '1501570619841810433', '1592120484120850434', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722632', '1501570619841810433', '1592120427007012865', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722633', '1501570619841810433', '1592120372296511490', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722634', '1501570619841810433', '1592120323667750914', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722635', '1501570619841810433', '1592113148350263298', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722636', '1501570619841810433', '1592112984361365505', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722637', '1501570619841810433', '1592115914493751297', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722638', '1501570619841810433', '1592116663936184322', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722639', '1501570619841810433', '1592118604640645122', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722640', '1501570619841810433', '1592118648315932674', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722641', '1501570619841810433', '1592119001883176961', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722642', '1501570619841810433', '1592120052866707457', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722643', '1501570619841810433', '1592120222727630849', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722644', '1501570619841810433', '1592117422006300673', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722645', '1501570619841810433', '1592117377299214337', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722646', '1501570619841810433', '1592117276539449345', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722647', '1501570619841810433', '1592117222764277761', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722648', '1501570619841810433', '1592115712466710529', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722649', '1501570619841810433', '1592118053634928641', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722650', '1501570619841810433', '1592117990305132545', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722651', '1501570619841810433', '1592117804359053314', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722652', '1501570619841810433', '1592117748209905665', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722653', '1501570619841810433', '1592117625664925697', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722654', '1501570619841810433', '1592118414990995457', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444669722655', '1501570619841810433', '1592118356778250241', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444732637186', '1501570619841810433', '1592118306983473154', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444732637187', '1501570619841810433', '1592118254844080130', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444732637188', '1501570619841810433', '1592118192218927105', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1593150444732637189', '1501570619841810433', '1592118497606201346', NULL, '2022-11-17 15:54:00', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286053158913', '1501570619841810433', '1592135223910765570', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286069936130', '1501570619841810433', '1593185714482880514', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286069936131', '1501570619841810433', '15c92115213910765570', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286069936132', '1501570619841810433', '1d592115213910765570', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286069936133', '1501570619841810433', '1592120224120850434', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286078324740', '1501570619841810433', '1593160959633563650', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286086713346', '1501570619841810433', '1593160905216663554', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286086713347', '1501570619841810433', '1593161025790320641', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286086713348', '1501570619841810433', '1593161089787011074', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286090907650', '1501570619841810433', '1596335805278990338', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286090907651', '1501570619841810433', '1596141938193747970', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286090907652', '1501570619841810433', '1600105607009165314', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286090907653', '1501570619841810433', '1600108123037917186', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286090907654', '1501570619841810433', '1600129606082650113', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286095101953', '1501570619841810433', '1611620416187969538', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286095101954', '1501570619841810433', '1611620600003342337', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286095101955', '1501570619841810433', '1611620654621569026', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286095101956', '1501570619841810433', '1611620772498218641', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286095101957', '1501570619841810433', '1611620772498288641', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286095101958', '1501570619841810433', '1611650772498288641', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296258', '1501570619841810433', '1612438989792034818', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296259', '1501570619841810433', '1613620712498288641', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296260', '1501570619841810433', '1620261087828418562', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296261', '1501570619841810433', '1620305415648989186', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296262', '1501570619841810433', '1697220712498288641', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296263', '1501570619841810433', '1621620772498288641', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296264', '1501570619841810433', '1620327825894981634', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296265', '1501570619841810433', '1593161743607701505', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296266', '1501570619841810433', '1593161697348722689', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296267', '1501570619841810433', '1593161657385394177', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296268', '1501570619841810433', '1593161608362369026', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296269', '1501570619841810433', '1593161551202394114', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286099296270', '1501570619841810433', '1593161483627962370', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286107684866', '1501570619841810433', '1593161421350936578', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1631912286107684867', '1501570619841810433', '1594930803956920321', NULL, '2023-03-04 14:59:43', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1657938323991883777', '1501570619841810433', '1473927410093187073', NULL, '2023-05-15 10:37:54', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1657938324004466690', '1501570619841810433', '1542385335362383873', NULL, '2023-05-15 10:37:54', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1657938324004466691', '1501570619841810433', '1554384900763729922', NULL, '2023-05-15 10:37:54', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779486212097', 'f6817f48af4fb3af11b9e8bf182f618b', '1542385335362383873', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779486212098', 'f6817f48af4fb3af11b9e8bf182f618b', '1554384900763729922', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377921', 'f6817f48af4fb3af11b9e8bf182f618b', '1600105607009165314', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377922', 'f6817f48af4fb3af11b9e8bf182f618b', '1600108123037917186', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377923', 'f6817f48af4fb3af11b9e8bf182f618b', '1600129606082650113', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377924', 'f6817f48af4fb3af11b9e8bf182f618b', '1611620416187969538', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377925', 'f6817f48af4fb3af11b9e8bf182f618b', '1611620600003342337', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377926', 'f6817f48af4fb3af11b9e8bf182f618b', '1611620654621569026', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377927', 'f6817f48af4fb3af11b9e8bf182f618b', '1611620772498218641', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377928', 'f6817f48af4fb3af11b9e8bf182f618b', '1611620772498288641', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377929', 'f6817f48af4fb3af11b9e8bf182f618b', '1611650772498288641', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377930', 'f6817f48af4fb3af11b9e8bf182f618b', '1612438989792034818', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779511377931', 'f6817f48af4fb3af11b9e8bf182f618b', '1613620712498288641', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779519766529', 'f6817f48af4fb3af11b9e8bf182f618b', '1620261087828418562', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779519766530', 'f6817f48af4fb3af11b9e8bf182f618b', '1620305415648989186', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779519766531', 'f6817f48af4fb3af11b9e8bf182f618b', '1620327825894981634', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779519766532', 'f6817f48af4fb3af11b9e8bf182f618b', '1621620772498288641', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779519766534', 'f6817f48af4fb3af11b9e8bf182f618b', '1697220712498288641', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779549126660', 'f6817f48af4fb3af11b9e8bf182f618b', '1211885237487923202', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779549126663', 'f6817f48af4fb3af11b9e8bf182f618b', '1438108176273760258', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779549126664', 'f6817f48af4fb3af11b9e8bf182f618b', '1438108176814825473', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779578486797', 'f6817f48af4fb3af11b9e8bf182f618b', '1443391584864358402', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779586875405', 'f6817f48af4fb3af11b9e8bf182f618b', '119213522910765570', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779591069698', 'f6817f48af4fb3af11b9e8bf182f618b', '1597419994965786625', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779603652610', 'f6817f48af4fb3af11b9e8bf182f618b', '1439542701152575489', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1693199779612041221', 'f6817f48af4fb3af11b9e8bf182f618b', '1438782851980210178', NULL, '2023-08-20 17:54:20', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('16ef8ed3865ccc6f6306200760896c50', 'ee8626f80f7c2619917b6236f3a7f02b', 'e8af452d8948ea49d37c934f5100ae6a', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1703032629144289281', 'f6817f48af4fb3af11b9e8bf182f618b', '1609123240547344385', NULL, '2023-09-16 21:06:34', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1703032629144289282', 'f6817f48af4fb3af11b9e8bf182f618b', '1609123437247619074', NULL, '2023-09-16 21:06:34', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1703032629144289283', 'f6817f48af4fb3af11b9e8bf182f618b', '1609164542165012482', NULL, '2023-09-16 21:06:34', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1703032629211398145', 'f6817f48af4fb3af11b9e8bf182f618b', '1609164635442139138', NULL, '2023-09-16 21:06:34', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714210633966919681', '1501570619841810433', '1629109281748291586', NULL, '2023-10-17 17:23:58', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714210633966919682', '1501570619841810433', '1701575168519839746', NULL, '2023-10-17 17:23:58', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714210633966919684', '1501570619841810433', '1609123240547344385', NULL, '2023-10-17 17:23:58', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714210633975308289', '1501570619841810433', '1609123437247619074', NULL, '2023-10-17 17:23:58', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714210633975308290', '1501570619841810433', '1609164635442139138', NULL, '2023-10-17 17:23:58', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714210633975308291', '1501570619841810433', '1609164542165012482', NULL, '2023-10-17 17:23:58', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714210633979502596', '1501570619841810433', '1663816667704500225', NULL, '2023-10-17 17:23:58', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714210633979502597', '1501570619841810433', '1660568280725127169', NULL, '2023-10-17 17:23:58', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714210633979502598', '1501570619841810433', '1660568368558047234', NULL, '2023-10-17 17:23:58', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714210633979502599', '1501570619841810433', '1660568426632380417', NULL, '2023-10-17 17:23:58', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1714215494145949698', '1501570619841810433', '1693195557097164801', NULL, '2023-10-17 17:43:17', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1741323995489972230', '1501570619841810433', '1701475606988812289', NULL, '2023-12-31 13:02:47', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1741323995489972231', '1501570619841810433', '1699039192154071041', NULL, '2023-12-31 13:02:47', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1741323995489972232', '1501570619841810433', '1699039098474291201', NULL, '2023-12-31 13:02:47', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1741323995498360833', '1501570619841810433', '1699038961937113090', NULL, '2023-12-31 13:02:47', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1741323995498360834', '1501570619841810433', '1698650926200352770', NULL, '2023-12-31 13:02:47', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1741324948112879617', '1501570619841810433', '1737321792727388161', NULL, '2023-12-31 13:06:35', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1765276463387095042', '1501570619841810433', '1750128461040648193', NULL, '2024-03-06 15:21:21', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1765276463395483650', '1501570619841810433', '1592114721138765826', NULL, '2024-03-06 15:21:21', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('17ead5b7d97ed365398ab20009a69ea3', '52b0cf022ac4187b2a70dfa4f8b2d940', 'e08cb190ef230d5d4f03824198773950', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1800736354410942469', 'f6817f48af4fb3af11b9e8bf182f618b', '1701475606988812289', NULL, '2024-06-12 11:46:18', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1800736354410942470', 'f6817f48af4fb3af11b9e8bf182f618b', '1699039098474291201', NULL, '2024-06-12 11:46:18', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1800736354410942471', 'f6817f48af4fb3af11b9e8bf182f618b', '1699039192154071041', NULL, '2024-06-12 11:46:18', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1800736354410942472', 'f6817f48af4fb3af11b9e8bf182f618b', '1699038961937113090', NULL, '2024-06-12 11:46:18', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1800736354410942473', 'f6817f48af4fb3af11b9e8bf182f618b', '1698650926200352770', NULL, '2024-06-12 11:46:18', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1802906584184770561', '1501570619841810433', 'f15543b0263cf6c5fac85afdd3eba3f2', NULL, '2024-06-18 11:30:01', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1804046501195509761', '1501570619841810433', '1804046424930480129', NULL, '2024-06-21 14:59:38', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1833351001521393666', '1501570619841810433', '1800372628805861377', NULL, '2024-09-10 11:45:15', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1833351001521393667', '1501570619841810433', '1800372727493640194', NULL, '2024-09-10 11:45:15', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1833351001521393668', '1501570619841810433', '1800372811518132225', NULL, '2024-09-10 11:45:15', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1833351001521393669', '1501570619841810433', '1800372906330374146', NULL, '2024-09-10 11:45:15', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1833351001521393670', '1501570619841810433', '1800373633509441537', NULL, '2024-09-10 11:45:15', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1833351001521393671', '1501570619841810433', '1800373733220630530', NULL, '2024-09-10 11:45:15', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1833408020878077953', '1501570619841810433', '1810923799513612290', NULL, '2024-09-10 15:31:50', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1833408020961964033', '1501570619841810433', '1811685368354754561', NULL, '2024-09-10 15:31:50', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1833408020961964034', '1501570619841810433', '1811685464467230721', NULL, '2024-09-10 15:31:50', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1887778978006814721', '1501570619841810433', '1887447660072292354', NULL, '2025-02-07 16:22:36', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1892117657990971393', '1456165677820301314', '1876220177009315842', NULL, '2025-02-19 15:42:58', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1892117657990971394', '1456165677820301314', '1867047795019440130', NULL, '2025-02-19 15:42:58', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1892117657990971395', '1456165677820301314', '1867041505346019330', NULL, '2025-02-19 15:42:58', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1892509406223613954', '1501570619841810433', '1876220177009315842', NULL, '2025-02-20 17:39:38', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1907441306927063042', 'f6817f48af4fb3af11b9e8bf182f618b', '1907441271556497409', NULL, '2025-04-02 22:33:41', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1923218155547787265', '1501570619841810433', '1892553163993931777', NULL, '2025-05-16 11:25:15', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1923218155547787266', '1501570619841810433', '1895401981290643458', NULL, '2025-05-16 11:25:15', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1923218155547787267', '1501570619841810433', '1892553778493022209', NULL, '2025-05-16 11:25:15', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1923218155547787268', '1501570619841810433', '1890213291321749505', NULL, '2025-05-16 11:25:15', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1923218155547787269', '1501570619841810433', '1892557342028226561', NULL, '2025-05-16 11:25:15', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1923218155547787270', '1501570619841810433', '1893865471550578689', NULL, '2025-05-16 11:25:15', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693122', '1501570619841810433', '1922109301837606914', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693123', '1501570619841810433', '2025050104193340030', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693124', '1501570619841810433', '2025050104193350031', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693125', '1501570619841810433', '2025050104193350032', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693126', '1501570619841810433', '2025050104193350033', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693127', '1501570619841810433', '2025050104193350034', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693128', '1501570619841810433', '2025050104193350035', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693129', '1501570619841810433', '2025050104193350036', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693130', '1501570619841810433', '2025050105554940200', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693131', '1501570619841810433', '2025050105554940201', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693132', '1501570619841810433', '2025050105554940202', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693133', '1501570619841810433', '2025050105554940203', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693134', '1501570619841810433', '2025050105554940204', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693135', '1501570619841810433', '2025050105554940205', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693136', '1501570619841810433', '2025050105554940206', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937756570658693137', '1501570619841810433', '1917957565728198657', NULL, '2025-06-25 14:15:43', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330064568321', '1501570619841810433', '1930222558582472705', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330077151234', '1501570619841810433', '1930222617197871105', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330085539842', '1501570619841810433', '1930222679269376001', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330085539843', '1501570619841810433', '1930222862556266498', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330085539844', '1501570619841810433', '1930222953853681666', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330085539845', '1501570619841810433', '1930223034757611522', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330089734145', '1501570619841810433', '1930223132619112449', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330089734146', '1501570619841810433', '1930221570324758530', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330089734147', '1501570619841810433', '1930221637551063042', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330089734148', '1501570619841810433', '1930221702164316161', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330089734149', '1501570619841810433', '1930221774230847490', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330089734150', '1501570619841810433', '1930221983555977217', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330089734151', '1501570619841810433', '1930222066120851457', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330093928450', '1501570619841810433', '1930222218734796802', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330093928451', '1501570619841810433', '1930222295012409345', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330093928452', '1501570619841810433', '1930222395180777474', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330098122753', '1501570619841810433', '1930221213607591937', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1937789330098122754', '1501570619841810433', '1930221335938662401', NULL, '2025-06-25 16:25:53', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1938073430981754881', '1501570619841810433', '1912753560201089025', NULL, '2025-06-26 11:14:48', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1950486711935152129', '1501570619841810433', '1939572818833301506', NULL, '2025-07-30 17:20:45', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1950487483951329281', '1501570619841810433', '1941349246536998913', NULL, '2025-07-30 17:23:49', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1950487483951329282', '1501570619841810433', '1941349335431077889', NULL, '2025-07-30 17:23:49', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1950487483959717889', '1501570619841810433', '1941349462887587842', NULL, '2025-07-30 17:23:49', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1950487483959717890', '1501570619841810433', '1941349550087168001', NULL, '2025-07-30 17:23:49', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962489414454194178', '1962488045068464130', '1609123240547344385', NULL, '2025-09-01 20:15:12', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251539722241', '1962488045068464130', '1674708136602542082', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251548110850', '1962488045068464130', '1663816667704500225', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251552305154', '1962488045068464130', '119213522910765570', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251552305155', '1962488045068464130', '1592114574275211345', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251560693762', '1962488045068464130', '1960994076329316353', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251560693763', '1962488045068464130', '1214462306546319322', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251560693764', '1962488045068464130', '1597419994965786625', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251560693765', '1962488045068464130', '1592102143467200514', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251569082370', '1962488045068464130', '1592114893302823614', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251569082371', '1962488045068464130', '1592120323667750934', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251569082372', '1962488045068464130', '1592120372296522490', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251569082373', '1962488045068464130', '1592120427223412865', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251573276674', '1962488045068464130', '1961009998209257473', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251573276675', '1962488045068464130', '1592115712422330529', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251573276676', '1962488045068464130', '1592117222764277032', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251573276677', '1962488045068464130', '1592117276539449346', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251581665281', '1962488045068464130', '1592117377299214338', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251581665282', '1962488045068464130', '1961253156897710081', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251585859586', '1962488045068464130', '1600105607009162230', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251585859587', '1962488045068464130', '1600108123037913486', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962765251585859588', '1962488045068464130', '1609123240547344376', NULL, '2025-09-02 14:31:17', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1962766200899461121', '1962488045068464130', '1592114955650691174', NULL, '2025-09-02 14:35:03', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1963068885343252482', '1962488045068464130', '1600129606082650123', NULL, '2025-09-03 10:37:49', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1963086686351036418', '1962488045068464130', '1963086454217281537', NULL, '2025-09-03 11:48:33', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1963133491872829442', '1962488045068464130', '1963133393868722178', NULL, '2025-09-03 14:54:32', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1963153837854330881', 'ee8626f80f7c2619917b6236f3a7f02b', '1596141938193747970', NULL, '2025-09-03 16:15:23', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1963153837854330882', 'ee8626f80f7c2619917b6236f3a7f02b', '1596335805278990338', NULL, '2025-09-03 16:15:23', '192.168.1.6');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986050090584666113', 'f6817f48af4fb3af11b9e8bf182f618b', '1853005', NULL, '2025-11-05 20:36:55', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468154421252', 'f6817f48af4fb3af11b9e8bf182f618b', '1592102143467200514', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468154421253', 'f6817f48af4fb3af11b9e8bf182f618b', '1592114893302823614', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468154421254', 'f6817f48af4fb3af11b9e8bf182f618b', '1592114955650691174', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468154421255', 'f6817f48af4fb3af11b9e8bf182f618b', '1592120323667750934', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468158615554', 'f6817f48af4fb3af11b9e8bf182f618b', '1592120372296522490', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468158615555', 'f6817f48af4fb3af11b9e8bf182f618b', '1592120427223412865', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468158615556', 'f6817f48af4fb3af11b9e8bf182f618b', '1963133393868722178', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468158615557', 'f6817f48af4fb3af11b9e8bf182f618b', '1674708136602542082', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468158615558', 'f6817f48af4fb3af11b9e8bf182f618b', '1961009998209257473', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468158615559', 'f6817f48af4fb3af11b9e8bf182f618b', '1592115712422330529', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468158615560', 'f6817f48af4fb3af11b9e8bf182f618b', '1592117222764277032', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468162809858', 'f6817f48af4fb3af11b9e8bf182f618b', '1592117276539449346', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468162809859', 'f6817f48af4fb3af11b9e8bf182f618b', '1592117377299214338', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468162809860', 'f6817f48af4fb3af11b9e8bf182f618b', '1961253156897710081', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468162809861', 'f6817f48af4fb3af11b9e8bf182f618b', '1600105607009162230', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468162809862', 'f6817f48af4fb3af11b9e8bf182f618b', '1600108123037913486', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468162809863', 'f6817f48af4fb3af11b9e8bf182f618b', '1609123240547344376', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1986099468171198469', 'f6817f48af4fb3af11b9e8bf182f618b', '1887447660072292354', NULL, '2025-11-05 23:53:08', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557258338306', '1988235440530857986', '1438108176273760258', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557258338307', '1988235440530857986', '1853001', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557262532610', '1988235440530857986', '1853006', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557262532611', '1988235440530857986', '1853006001', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557262532612', '1988235440530857986', '1853006002', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557262532613', '1988235440530857986', '1853002', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557266726913', '1988235440530857986', '1853002001', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557266726914', '1988235440530857986', '1853002002', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557266726915', '1988235440530857986', '1853002003', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557266726916', '1988235440530857986', '1853002004', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557266726917', '1988235440530857986', '1853004', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988235557270921218', '1988235440530857986', '1853004001', NULL, '2025-11-11 21:21:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988580777388908545', '1988235440530857986', '1592114772665790465', NULL, '2025-11-12 20:12:58', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988580777388908546', '1988235440530857986', '1596141938193747970', NULL, '2025-11-12 20:12:58', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988580777388908547', '1988235440530857986', '1596335805278990338', NULL, '2025-11-12 20:12:58', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1988583330482724865', 'f6817f48af4fb3af11b9e8bf182f618b', '1988583175138287618', NULL, '2025-11-12 20:23:07', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1997619857919410177', 'f6817f48af4fb3af11b9e8bf182f618b', 'fff54234d35911f08076525400e87d0c', NULL, '2025-12-07 18:51:03', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1999079622490329089', 'f6817f48af4fb3af11b9e8bf182f618b', '1999079554806845441', NULL, '2025-12-11 19:31:38', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1ac1688ef8456f384091a03d88a89ab1', '52b0cf022ac4187b2a70dfa4f8b2d940', '693ce69af3432bd00be13c3971a57961', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1af4babaa4227c3cbb830bc5eb513abb', 'ee8626f80f7c2619917b6236f3a7f02b', 'e08cb190ef230d5d4f03824198773950', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1ba162bbc2076c25561f8622f610d5bf', 'ee8626f80f7c2619917b6236f3a7f02b', 'aedbf679b5773c1f25e9f7b10111da73', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('1fe4d408b85f19618c15bcb768f0ec22', '1750a8fb3e6d90cb7957c02de1dc8e59', '9502685863ab87f0ad1134142788a385', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2000567291116556290', 'f6817f48af4fb3af11b9e8bf182f618b', '1443390062919208961', NULL, '2025-12-15 22:03:06', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659040620545', '092e7af7e18e11f08076525400e87d0c', '1438108176273760258', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659049009153', '092e7af7e18e11f08076525400e87d0c', '9502685863ab87f0ad1134142788a385', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659049009154', '092e7af7e18e11f08076525400e87d0c', '1853006', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659049009155', '092e7af7e18e11f08076525400e87d0c', '1853006002', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659049009156', '092e7af7e18e11f08076525400e87d0c', '1853006001', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659049009157', '092e7af7e18e11f08076525400e87d0c', '1853002', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659049009158', '092e7af7e18e11f08076525400e87d0c', '1853002001', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659049009159', '092e7af7e18e11f08076525400e87d0c', '1853002002', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659049009160', '092e7af7e18e11f08076525400e87d0c', '1853002003', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397762', '092e7af7e18e11f08076525400e87d0c', '1853002004', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397763', '092e7af7e18e11f08076525400e87d0c', '1853002005', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397764', '092e7af7e18e11f08076525400e87d0c', '1853003', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397765', '092e7af7e18e11f08076525400e87d0c', '1853003001', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397766', '092e7af7e18e11f08076525400e87d0c', '1853003002', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397767', '092e7af7e18e11f08076525400e87d0c', '1853003003', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397768', '092e7af7e18e11f08076525400e87d0c', '1853003004', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397769', '092e7af7e18e11f08076525400e87d0c', '1853004', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397770', '092e7af7e18e11f08076525400e87d0c', '1988583175138287618', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397771', '092e7af7e18e11f08076525400e87d0c', '1853004001', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397772', '092e7af7e18e11f08076525400e87d0c', '1853004002', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004175659057397773', '092e7af7e18e11f08076525400e87d0c', 'fff54234d35911f08076525400e87d0c', NULL, '2025-12-25 21:01:28', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004191424032616450', '092e7af7e18e11f08076525400e87d0c', '1853001', NULL, '2025-12-25 22:04:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004728248584916993', '092e7af7e18e11f08076525400e87d0c', '1999079554806845441', NULL, '2025-12-27 09:37:15', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004733232814772225', '1988235440530857986', '1438108176814825473', NULL, '2025-12-27 09:57:04', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004734437116891138', '1988235440530857986', '1999079554806845441', NULL, '2025-12-27 10:01:51', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004784475746725890', '092e7af7e18e11f08076525400e87d0c', '1588513553652436993', NULL, '2025-12-27 13:20:41', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004784475750920194', '092e7af7e18e11f08076525400e87d0c', '1750128461040648193', NULL, '2025-12-27 13:20:41', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004785794108682241', '092e7af7e18e11f08076525400e87d0c', '1592114772665790465', NULL, '2025-12-27 13:25:55', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650932715521', 'f6817f48af4fb3af11b9e8bf182f618b', '1592114574275211345', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104129', 'f6817f48af4fb3af11b9e8bf182f618b', '1600129606082650123', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104131', 'f6817f48af4fb3af11b9e8bf182f618b', '1876220177009315842', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104132', 'f6817f48af4fb3af11b9e8bf182f618b', '1947833384695164929', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104133', 'f6817f48af4fb3af11b9e8bf182f618b', '1960994076329316353', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104134', 'f6817f48af4fb3af11b9e8bf182f618b', '1214462306546319322', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104135', 'f6817f48af4fb3af11b9e8bf182f618b', '5a4c0169d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104136', 'f6817f48af4fb3af11b9e8bf182f618b', '5a6bb384d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104137', 'f6817f48af4fb3af11b9e8bf182f618b', 'be203e04d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104138', 'f6817f48af4fb3af11b9e8bf182f618b', 'be36b49dd24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104139', 'f6817f48af4fb3af11b9e8bf182f618b', '5a4c0847d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104140', 'f6817f48af4fb3af11b9e8bf182f618b', '5a6bb8eed24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104141', 'f6817f48af4fb3af11b9e8bf182f618b', 'be20441dd24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104142', 'f6817f48af4fb3af11b9e8bf182f618b', 'be36baffd24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650941104143', 'f6817f48af4fb3af11b9e8bf182f618b', '5a4c0a3bd24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650945298433', 'f6817f48af4fb3af11b9e8bf182f618b', '5a6bba69d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650945298434', 'f6817f48af4fb3af11b9e8bf182f618b', 'be2045d6d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650945298435', 'f6817f48af4fb3af11b9e8bf182f618b', 'be36bca2d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650945298436', 'f6817f48af4fb3af11b9e8bf182f618b', '5a4c0b98d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650945298437', 'f6817f48af4fb3af11b9e8bf182f618b', '5a6bbba4d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650949492738', 'f6817f48af4fb3af11b9e8bf182f618b', 'be204719d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650949492739', 'f6817f48af4fb3af11b9e8bf182f618b', 'be38b0e5d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650949492740', 'f6817f48af4fb3af11b9e8bf182f618b', '5a2f4b88d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650949492741', 'f6817f48af4fb3af11b9e8bf182f618b', '5a4c0ce7d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650949492742', 'f6817f48af4fb3af11b9e8bf182f618b', 'be0dc86ed24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650949492743', 'f6817f48af4fb3af11b9e8bf182f618b', 'be204859d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650949492744', 'f6817f48af4fb3af11b9e8bf182f618b', '5a4c0e13d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650949492745', 'f6817f48af4fb3af11b9e8bf182f618b', '5a57c04ed24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650949492746', 'f6817f48af4fb3af11b9e8bf182f618b', 'be204a83d24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004829650949492747', 'f6817f48af4fb3af11b9e8bf182f618b', 'be27f66bd24811f0ac2a5254006b23b9', NULL, '2025-12-27 16:20:11', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004847156250451969', 'f6817f48af4fb3af11b9e8bf182f618b', 'menu_agent_center', NULL, '2025-12-27 17:29:45', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004847156258840578', 'f6817f48af4fb3af11b9e8bf182f618b', 'menu_finance_center', NULL, '2025-12-27 17:29:45', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2004847156258840579', 'f6817f48af4fb3af11b9e8bf182f618b', 'menu_operation', NULL, '2025-12-27 17:29:45', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443367170050', '2006015005280505857', '1438108176273760258', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443371364353', '2006015005280505857', '9502685863ab87f0ad1134142788a385', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443371364354', '2006015005280505857', '1438108176814825473', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443371364355', '2006015005280505857', '1853001', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443371364356', '2006015005280505857', '1853006', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443371364357', '2006015005280505857', '1853006001', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443371364358', '2006015005280505857', '1853006002', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443371364359', '2006015005280505857', '1853002', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443379752962', '2006015005280505857', '1853002001', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443379752963', '2006015005280505857', '1853002002', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443379752964', '2006015005280505857', '1853002003', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443379752965', '2006015005280505857', '1853002004', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443379752966', '2006015005280505857', '1853002005', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443379752967', '2006015005280505857', '1853003', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443379752968', '2006015005280505857', '1853003001', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947265', '2006015005280505857', '1853003002', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947266', '2006015005280505857', '1853003003', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947267', '2006015005280505857', '1853003004', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947268', '2006015005280505857', '1853001001', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947269', '2006015005280505857', 'menu_agent_center', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947270', '2006015005280505857', 'fff54234d35911f08076525400e87d0c', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947271', '2006015005280505857', 'd7d6e2e4e2934f2c9385a623fd98c6f3', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947272', '2006015005280505857', '1170592628746878978', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947273', '2006015005280505857', '1592112984361365505', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947274', '2006015005280505857', '1592115914493751297', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947275', '2006015005280505857', '1592116663936184322', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947276', '2006015005280505857', '1592118604640645122', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443383947277', '2006015005280505857', '1592118648315932674', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335874', '2006015005280505857', '1592119001883176961', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335875', '2006015005280505857', '1592120052866707457', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335876', '2006015005280505857', '1750128461040648193', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335877', '2006015005280505857', '1939572818833301506', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335878', '2006015005280505857', '1941349246536998913', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335879', '2006015005280505857', '1941349335431077889', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335880', '2006015005280505857', '1941349462887587842', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335881', '2006015005280505857', '1941349550087168001', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335882', '2006015005280505857', '3f915b2769fc80648e92d04e84ca059d', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335883', '2006015005280505857', '1588513553652436993', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335884', '2006015005280505857', '1592114574275211265', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335885', '2006015005280505857', '1592114652566089729', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443392335886', '2006015005280505857', '1592114721138765826', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443400724481', '2006015005280505857', '1592114772665790465', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443400724482', '2006015005280505857', '1592114823467200514', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443400724483', '2006015005280505857', '1592114893302362114', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918785', '2006015005280505857', '1592114955650691074', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918786', '2006015005280505857', '1592115070432014338', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918787', '2006015005280505857', '1592115115361398786', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918788', '2006015005280505857', '1592115162379546625', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918789', '2006015005280505857', '1592115213910765570', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918790', '2006015005280505857', '1592135223910765570', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918791', '2006015005280505857', '1593185714482880514', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918792', '2006015005280505857', '15c92115213910765570', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918793', '2006015005280505857', '1808098125316870145', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918794', '2006015005280505857', '1d592115213910765570', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918795', '2006015005280505857', '1214376304951664642', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918796', '2006015005280505857', '1214462306546319362', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918797', '2006015005280505857', '1a0811914300741f4e11838ff37a1d3a', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443404918798', '2006015005280505857', 'f15543b0263cf6c5fac85afdd3eba3f2', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307393', '2006015005280505857', '190c2b43bec6a5f7a4194a85db67d96a', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307394', '2006015005280505857', '1592113148350263298', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307395', '2006015005280505857', '1592120224120850434', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307396', '2006015005280505857', '1592120323667750914', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307397', '2006015005280505857', '1592120372296511490', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307398', '2006015005280505857', '1592120427007012865', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307399', '2006015005280505857', '1592120484120850434', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307400', '2006015005280505857', '1592120594695286785', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307401', '2006015005280505857', '1592120649007329281', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307402', '2006015005280505857', '1693195557097164801', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307403', '2006015005280505857', '45c966826eeff4c99b8f8ebfe74511fc', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307404', '2006015005280505857', '1592115712466710529', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443413307405', '2006015005280505857', '1592117222764277761', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443421696002', '2006015005280505857', '1592117276539449345', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443421696003', '2006015005280505857', '1592117377299214337', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443421696004', '2006015005280505857', '1592117422006300673', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443421696005', '2006015005280505857', '1592120222727630849', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443421696006', '2006015005280505857', '5c2f42277948043026b7a14692456828', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443421696007', '2006015005280505857', '1592117625664925697', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443421696008', '2006015005280505857', '1592117748209905665', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443421696009', '2006015005280505857', '1592117804359053314', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890305', '2006015005280505857', '1592117990305132545', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890306', '2006015005280505857', '1592118053634928641', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890307', '2006015005280505857', '1438782641187074050', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890308', '2006015005280505857', '1592118192218927105', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890309', '2006015005280505857', '1592118254844080130', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890310', '2006015005280505857', '1592118306983473154', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890311', '2006015005280505857', '1592118356778250241', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890312', '2006015005280505857', '1592118414990995457', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890313', '2006015005280505857', '1593160905216663554', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890314', '2006015005280505857', '1593160959633563650', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890315', '2006015005280505857', '1593161025790320641', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890316', '2006015005280505857', '1593161089787011074', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890317', '2006015005280505857', '1810652607946940417', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890318', '2006015005280505857', '1701575168519839746', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443425890319', '2006015005280505857', '1800372628805861377', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278914', '2006015005280505857', '1800372727493640194', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278915', '2006015005280505857', '1800372811518132225', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278916', '2006015005280505857', '1800372906330374146', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278917', '2006015005280505857', '1800373633509441537', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278918', '2006015005280505857', '1800373733220630530', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278919', '2006015005280505857', '1438782530717495298', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278920', '2006015005280505857', '1596141938193747970', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278921', '2006015005280505857', '1596335805278990338', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278922', '2006015005280505857', 'menu_finance_center', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278923', '2006015005280505857', '1853004', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278924', '2006015005280505857', '1988583175138287618', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278925', '2006015005280505857', '1853004001', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278926', '2006015005280505857', '1853004002', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278927', '2006015005280505857', '1997148797176389634', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278928', '2006015005280505857', '1674708136602542082', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278929', '2006015005280505857', '1963133393868722178', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443434278930', '2006015005280505857', '119213522910765570', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443442667522', '2006015005280505857', '1597419994965786625', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443442667523', '2006015005280505857', '1592102143467200514', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443442667524', '2006015005280505857', '1592114893302823614', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443442667525', '2006015005280505857', '1592114955650691174', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443442667526', '2006015005280505857', '1592120323667750934', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443442667527', '2006015005280505857', '1592120372296522490', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443442667528', '2006015005280505857', '1592120427223412865', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443442667529', '2006015005280505857', '1961009998209257473', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443446861826', '2006015005280505857', '1592115712422330529', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443446861827', '2006015005280505857', '1592117222764277032', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443446861828', '2006015005280505857', '1592117276539449346', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443446861829', '2006015005280505857', '1592117377299214338', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443446861830', '2006015005280505857', '1961253156897710081', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443446861831', '2006015005280505857', '1600105607009162230', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443446861832', '2006015005280505857', '1600108123037913486', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443446861833', '2006015005280505857', '1609123240547344376', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443451056129', '2006015005280505857', '1439398677984878593', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443451056130', '2006015005280505857', '1439399179791409153', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443451056131', '2006015005280505857', '1592118497606201346', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443451056132', '2006015005280505857', '1810923799513612290', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443451056133', '2006015005280505857', '1811685368354754561', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443451056134', '2006015005280505857', '1811685464467230721', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443451056135', '2006015005280505857', '1439488251473993730', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443451056136', '2006015005280505857', '1593161421350936578', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443451056137', '2006015005280505857', '1593161483627962370', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250433', '2006015005280505857', '1593161551202394114', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250434', '2006015005280505857', '1593161608362369026', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250435', '2006015005280505857', '1593161657385394177', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250436', '2006015005280505857', '1593161697348722689', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250437', '2006015005280505857', '1593161743607701505', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250438', '2006015005280505857', '1922109301837606914', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250439', '2006015005280505857', '2025050104193340030', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250440', '2006015005280505857', '2025050104193350031', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250441', '2006015005280505857', '2025050104193350032', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250442', '2006015005280505857', '2025050104193350033', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250443', '2006015005280505857', '2025050104193350034', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250444', '2006015005280505857', '2025050104193350035', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250445', '2006015005280505857', '2025050104193350036', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250446', '2006015005280505857', '2025050105554940200', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250447', '2006015005280505857', '2025050105554940201', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250448', '2006015005280505857', '2025050105554940202', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443455250449', '2006015005280505857', '2025050105554940203', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443463639042', '2006015005280505857', '2025050105554940204', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443463639043', '2006015005280505857', '2025050105554940205', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443463639044', '2006015005280505857', '2025050105554940206', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443463639045', '2006015005280505857', '1917957565728198657', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443463639046', '2006015005280505857', '1439533711676973057', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443463639047', '2006015005280505857', '1660568280725127169', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443463639048', '2006015005280505857', '1660568368558047234', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443463639049', '2006015005280505857', '1660568426632380417', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443463639050', '2006015005280505857', '1439531077792473089', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443463639051', '2006015005280505857', '1439784356766064642', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833345', '2006015005280505857', '1439797053314342913', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833346', '2006015005280505857', '1439839507094740994', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833347', '2006015005280505857', '1439842640030113793', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833348', '2006015005280505857', '1594930803956920321', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833349', '2006015005280505857', 'menu_operation', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833350', '2006015005280505857', '1999079554806845441', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833351', '2006015005280505857', '1280350452934307841', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833352', '2006015005280505857', '1600105607009165314', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833353', '2006015005280505857', '1600108123037917186', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833354', '2006015005280505857', '1600129606082650113', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833355', '2006015005280505857', '1609123240547344385', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833356', '2006015005280505857', '1609123437247619074', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833357', '2006015005280505857', '1609164542165012482', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833358', '2006015005280505857', '1609164635442139138', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833359', '2006015005280505857', '1611620416187969538', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833360', '2006015005280505857', '1611620600003342337', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833361', '2006015005280505857', '1611620654621569026', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833362', '2006015005280505857', '1611620772498218641', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833363', '2006015005280505857', '1611620772498288641', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443467833364', '2006015005280505857', '1611650772498288641', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443476221953', '2006015005280505857', '1612438989792034818', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443476221954', '2006015005280505857', '1613620712498288641', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443476221955', '2006015005280505857', '1620261087828418562', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443476221956', '2006015005280505857', '1620305415648989186', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443476221957', '2006015005280505857', '1620327825894981634', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443476221958', '2006015005280505857', '1621620772498288641', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443476221959', '2006015005280505857', '1697220712498288641', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443476221960', '2006015005280505857', '1887447660072292354', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443480416258', '2006015005280505857', '1853005', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443480416259', '2006015005280505857', '1853005001', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443480416260', '2006015005280505857', '1853005002', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443480416261', '2006015005280505857', '1853005003', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443480416262', '2006015005280505857', '1853005004', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443480416263', '2006015005280505857', '1443390062919208961', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443480416264', '2006015005280505857', '1443391584864358402', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443480416265', '2006015005280505857', '1439542701152575489', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2006015443480416266', '2006015005280505857', '1438782851980210178', NULL, '2025-12-30 22:52:06', '127.0.0.1');
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('248d288586c6ff3bd14381565df84163', '52b0cf022ac4187b2a70dfa4f8b2d940', '3f915b2769fc80648e92d04e84ca059d', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('25f5443f19c34d99718a016d5f54112e', 'ee8626f80f7c2619917b6236f3a7f02b', '6e73eb3c26099c191bf03852ee1310a1', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('27489816708b18859768dfed5945c405', 'a799c3b1b12dd3ed4bd046bfaef5fe6e', '9502685863ab87f0ad1134142788a385', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('296f9c75ca0e172ae5ce4c1022c996df', '646c628b2b8295fbdab2d34044de0354', '732d48f8e0abe99fe6a23d18a3171cd1', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('29fb4d37aa29b9fa400f389237cf9fe7', 'ee8626f80f7c2619917b6236f3a7f02b', '05b3c82ddb2536a4a5ee1a4c46b5abef', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2c462293cbb0eab7e8ae0a3600361b5f', '52b0cf022ac4187b2a70dfa4f8b2d940', '9502685863ab87f0ad1134142788a385', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2dc1a0eb5e39aaa131ddd0082a492d76', 'ee8626f80f7c2619917b6236f3a7f02b', '08e6b9dc3c04489c8e1ff2ce6f105aa4', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2ea2382af618ba7d1e80491a0185fb8a', 'ee8626f80f7c2619917b6236f3a7f02b', 'f23d9bfff4d9aa6b68569ba2cff38415', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2fcfa2ac3dcfadc7c67107dae9a0de6d', 'ee8626f80f7c2619917b6236f3a7f02b', '73678f9daa45ed17a3674131b03432fb', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('2fdaed22dfa4c8d4629e44ef81688c6a', '52b0cf022ac4187b2a70dfa4f8b2d940', 'aedbf679b5773c1f25e9f7b10111da73', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('300c462b7fec09e2ff32574ef8b3f0bd', '52b0cf022ac4187b2a70dfa4f8b2d940', '2a470fc0c3954d9dbb61de6d80846549', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('35ac7cae648de39eb56213ca1b649713', '52b0cf022ac4187b2a70dfa4f8b2d940', 'b1cb0a3fedf7ed0e4653cb5a229837ee', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('37112f4d372541e105473f18da3dc50d', 'ee8626f80f7c2619917b6236f3a7f02b', 'a400e4f4d54f79bf5ce160ae432231af', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('37789f70cd8bd802c4a69e9e1f633eaa', 'ee8626f80f7c2619917b6236f3a7f02b', 'ae4fed059f67086fd52a73d913cf473d', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('381504a717cb3ce77dcd4070c9689a7e', 'ee8626f80f7c2619917b6236f3a7f02b', '4f84f9400e5e92c95f05b554724c2b58', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('3e563751942b0879c88ca4de19757b50', '1750a8fb3e6d90cb7957c02de1dc8e59', '58857ff846e61794c69208e9d3a85466', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('412e2de37a35b3442d68db8dd2f3c190', '52b0cf022ac4187b2a70dfa4f8b2d940', 'f1cb187abf927c88b89470d08615f5ac', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('44b5a73541bcb854dd5d38c6d1fb93a1', 'ee8626f80f7c2619917b6236f3a7f02b', '418964ba087b90a84897b62474496b93', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('48866c23d25611f0ac2a5254006b23b9', 'f6817f48af4fb3af11b9e8bf182f618b', '1997148797176389634', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('4d56ce2f67c94b74a1d3abdbea340e42', 'ee8626f80f7c2619917b6236f3a7f02b', 'd86f58e7ab516d3bc6bfb1fe10585f97', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('4faad8ff93cb2b5607cd3d07c1b624ee', 'a799c3b1b12dd3ed4bd046bfaef5fe6e', '70b8f33da5f39de1981bf89cf6c99792', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('57c0b3a547b815ea3ec8e509b08948b3', '1750a8fb3e6d90cb7957c02de1dc8e59', '3f915b2769fc80648e92d04e84ca059d', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('593ee05c4fe4645c7826b7d5e14f23ec', '52b0cf022ac4187b2a70dfa4f8b2d940', '8fb8172747a78756c11916216b8b8066', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('5affc85021fcba07d81c09a6fdfa8dc6', 'ee8626f80f7c2619917b6236f3a7f02b', '078f9558cdeab239aecb2bda1a8ed0d1', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('5fc194b709336d354640fe29fefd65a3', 'a799c3b1b12dd3ed4bd046bfaef5fe6e', '9ba60e626bf2882c31c488aba62b89f0', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('6451dac67ba4acafb570fd6a03f47460', 'ee8626f80f7c2619917b6236f3a7f02b', 'e3c13679c73a4f829bcff2aba8fd68b1', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('6c43fd3f10fdaf2a0646434ae68709b5', 'ee8626f80f7c2619917b6236f3a7f02b', '540a2936940846cb98114ffb0d145cb8', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('71a5f54a90aa8c7a250a38b7dba39f6f', 'ee8626f80f7c2619917b6236f3a7f02b', '8fb8172747a78756c11916216b8b8066', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('75002588591820806', '16457350655250432', '5129710648430592', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('75002588604403712', '16457350655250432', '5129710648430593', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('75002588612792320', '16457350655250432', '40238597734928384', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('75002588625375232', '16457350655250432', '57009744761589760', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('75002588633763840', '16457350655250432', '16392452747300864', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('75002588637958144', '16457350655250432', '16392767785668608', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('75002588650541056', '16457350655250432', '16439068543946752', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277779875336192', '496138616573952', '5129710648430592', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780043108352', '496138616573952', '5129710648430593', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780055691264', '496138616573952', '15701400130424832', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780064079872', '496138616573952', '16678126574637056', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780072468480', '496138616573952', '15701915807518720', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780076662784', '496138616573952', '15708892205944832', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780085051392', '496138616573952', '16678447719911424', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780089245696', '496138616573952', '25014528525733888', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780097634304', '496138616573952', '56898976661639168', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780135383040', '496138616573952', '40238597734928384', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780139577344', '496138616573952', '45235621697949696', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780147965952', '496138616573952', '45235787867885568', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780156354560', '496138616573952', '45235939278065664', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780164743168', '496138616573952', '43117268627886080', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780168937472', '496138616573952', '45236734832676864', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780181520384', '496138616573952', '45237010692050944', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780189908992', '496138616573952', '45237170029465600', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780198297600', '496138616573952', '57009544286441472', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780206686208', '496138616573952', '57009744761589760', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780215074816', '496138616573952', '57009981228060672', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780219269120', '496138616573952', '56309618086776832', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780227657728', '496138616573952', '57212882168844288', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780236046336', '496138616573952', '61560041605435392', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780244434944', '496138616573952', '61560275261722624', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780257017856', '496138616573952', '61560480518377472', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780265406464', '496138616573952', '44986029924421632', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780324126720', '496138616573952', '45235228800716800', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780332515328', '496138616573952', '45069342940860416', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780340903937', '496138616573952', '5129710648430594', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780349292544', '496138616573952', '16687383932047360', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780357681152', '496138616573952', '16689632049631232', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780366069760', '496138616573952', '16689745006432256', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780370264064', '496138616573952', '16689883993083904', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780374458369', '496138616573952', '16690313745666048', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780387041280', '496138616573952', '5129710648430595', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780395429888', '496138616573952', '16694861252005888', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780403818496', '496138616573952', '16695107491205120', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780412207104', '496138616573952', '16695243126607872', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780420595712', '496138616573952', '75002207560273920', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780428984320', '496138616573952', '76215889006956544', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780433178624', '496138616573952', '76216071333351424', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780441567232', '496138616573952', '76216264070008832', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780449955840', '496138616573952', '76216459709124608', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780458344448', '496138616573952', '76216594207870976', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780466733056', '496138616573952', '76216702639017984', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780475121664', '496138616573952', '58480609315524608', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780483510272', '496138616573952', '61394706252173312', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780491898880', '496138616573952', '61417744146370560', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780496093184', '496138616573952', '76606430504816640', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780504481792', '496138616573952', '76914082455752704', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780508676097', '496138616573952', '76607201262702592', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780517064704', '496138616573952', '39915540965232640', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780525453312', '496138616573952', '41370251991977984', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780538036224', '496138616573952', '45264987354042368', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780546424832', '496138616573952', '45265487029866496', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780554813440', '496138616573952', '45265762415284224', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780559007744', '496138616573952', '45265886315024384', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780567396352', '496138616573952', '45266070000373760', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780571590656', '496138616573952', '41363147411427328', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780579979264', '496138616573952', '41363537456533504', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780588367872', '496138616573952', '41364927394353152', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780596756480', '496138616573952', '41371711400054784', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780605145088', '496138616573952', '41469219249852416', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780613533696', '496138616573952', '39916171171991552', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780621922304', '496138616573952', '39918482854252544', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780630310912', '496138616573952', '41373430515240960', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780718391296', '496138616573952', '41375330996326400', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780722585600', '496138616573952', '63741744973352960', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780730974208', '496138616573952', '42082442672082944', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780739362816', '496138616573952', '41376192166629376', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780747751424', '496138616573952', '41377034236071936', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780756140032', '496138616573952', '56911328312299520', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780764528640', '496138616573952', '41378916912336896', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780768722944', '496138616573952', '63482475359244288', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780772917249', '496138616573952', '64290663792906240', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780785500160', '496138616573952', '66790433014943744', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780789694464', '496138616573952', '42087054753927168', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780798083072', '496138616573952', '67027338952445952', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780806471680', '496138616573952', '67027909637836800', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780810665985', '496138616573952', '67042515441684480', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780823248896', '496138616573952', '67082402312228864', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780827443200', '496138616573952', '16392452747300864', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780835831808', '496138616573952', '16392767785668608', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780840026112', '496138616573952', '16438800255291392', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780844220417', '496138616573952', '16438962738434048', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277780852609024', '496138616573952', '16439068543946752', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860062040064', '496138616573953', '5129710648430592', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860070428672', '496138616573953', '5129710648430593', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860078817280', '496138616573953', '40238597734928384', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860091400192', '496138616573953', '43117268627886080', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860099788800', '496138616573953', '57009744761589760', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860112371712', '496138616573953', '56309618086776832', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860120760320', '496138616573953', '44986029924421632', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860129148928', '496138616573953', '5129710648430594', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860141731840', '496138616573953', '5129710648430595', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860150120448', '496138616573953', '75002207560273920', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860158509056', '496138616573953', '58480609315524608', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860162703360', '496138616573953', '76606430504816640', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860171091968', '496138616573953', '76914082455752704', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860179480576', '496138616573953', '76607201262702592', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860187869184', '496138616573953', '39915540965232640', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860196257792', '496138616573953', '41370251991977984', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860204646400', '496138616573953', '41363147411427328', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860208840704', '496138616573953', '41371711400054784', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860213035009', '496138616573953', '39916171171991552', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860221423616', '496138616573953', '39918482854252544', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860225617920', '496138616573953', '41373430515240960', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860234006528', '496138616573953', '41375330996326400', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860242395136', '496138616573953', '63741744973352960', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860250783744', '496138616573953', '42082442672082944', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860254978048', '496138616573953', '41376192166629376', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860263366656', '496138616573953', '41377034236071936', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860271755264', '496138616573953', '56911328312299520', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860313698304', '496138616573953', '41378916912336896', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860322086912', '496138616573953', '63482475359244288', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860326281216', '496138616573953', '64290663792906240', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860334669824', '496138616573953', '66790433014943744', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860343058432', '496138616573953', '42087054753927168', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860347252736', '496138616573953', '67027338952445952', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860351447041', '496138616573953', '67027909637836800', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860359835648', '496138616573953', '67042515441684480', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860364029952', '496138616573953', '67082402312228864', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860368224256', '496138616573953', '16392452747300864', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860372418560', '496138616573953', '16392767785668608', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860376612865', '496138616573953', '16438800255291392', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860385001472', '496138616573953', '16438962738434048', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('77277860389195776', '496138616573953', '16439068543946752', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('7750f9be48ee09cd561fce718219a3e2', 'ee8626f80f7c2619917b6236f3a7f02b', '882a73768cfd7f78f3a37584f7299656', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('7a5d31ba48fe3fb1266bf186dc5f7ba7', '52b0cf022ac4187b2a70dfa4f8b2d940', '58857ff846e61794c69208e9d3a85466', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('7d2ea745950be3357747ec7750c31c57', 'ee8626f80f7c2619917b6236f3a7f02b', '2a470fc0c3954d9dbb61de6d80846549', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('7de42bdc0b8c5446b7d428c66a7abc12', '52b0cf022ac4187b2a70dfa4f8b2d940', '54dd5457a3190740005c1bfec55b1c34', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('7e19d90cec0dd87aaef351b9ff8f4902', '646c628b2b8295fbdab2d34044de0354', 'f9d3f4f27653a71c52faa9fb8070fbe7', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('83f704524b21b6a3ae324b8736c65333', 'ee8626f80f7c2619917b6236f3a7f02b', '7ac9eb9ccbde2f7a033cd4944272bf1e', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('846bc6b4daab11f08076525400e87d0c', 'f6817f48af4fb3af11b9e8bf182f618b', '1853001001', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('846bcb9cdaab11f08076525400e87d0c', 'f6817f48af4fb3af11b9e8bf182f618b', '1853002005', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('846c3116daab11f08076525400e87d0c', 'f6817f48af4fb3af11b9e8bf182f618b', '1853004002', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('84d32474316a43b01256d6644e6e7751', 'ee8626f80f7c2619917b6236f3a7f02b', 'ec8d607d0156e198b11853760319c646', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('8703a2410cddb713c33232ce16ec04b9', 'ee8626f80f7c2619917b6236f3a7f02b', '1367a93f2c410b169faa7abcbad2f77c', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('885c1a827383e5b2c6c4f8ca72a7b493', 'ee8626f80f7c2619917b6236f3a7f02b', '4148ec82b6acd69f470bea75fe41c357', '', NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('8a60df8d8b4c9ee5fa63f48aeee3ec00', '1750a8fb3e6d90cb7957c02de1dc8e59', 'd7d6e2e4e2934f2c9385a623fd98c6f3', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('8b1e326791375f325d3e6b797753b65e', 'ee8626f80f7c2619917b6236f3a7f02b', '2dbbafa22cda07fa5d169d741b81fe12', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('8ce1022dac4e558ff9694600515cf510', '1750a8fb3e6d90cb7957c02de1dc8e59', '08e6b9dc3c04489c8e1ff2ce6f105aa4', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('8d848ca7feec5b7ebb3ecb32b2c8857a', '52b0cf022ac4187b2a70dfa4f8b2d940', '4148ec82b6acd69f470bea75fe41c357', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('8eec2c510f1ac9c5eee26c041b1f00ca', 'ee8626f80f7c2619917b6236f3a7f02b', '58857ff846e61794c69208e9d3a85466', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('903b790e6090414343502c6dc393b7c9', 'ee8626f80f7c2619917b6236f3a7f02b', 'de13e0f6328c069748de7399fcc1dbbd', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('90996d56357730e173e636b99fc48bea', 'ee8626f80f7c2619917b6236f3a7f02b', 'fb07ca05a3e13674dbf6d3245956da2e', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('90e1c607a0631364eec310f3cc4acebd', 'ee8626f80f7c2619917b6236f3a7f02b', '4f66409ef3bbd69c1d80469d6e2a885e', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('9264104cee9b10c96241d527b2d0346d', '1750a8fb3e6d90cb7957c02de1dc8e59', '54dd5457a3190740005c1bfec55b1c34', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('98f02353f91dd569e3c6b8fd6b4f4034', 'ee8626f80f7c2619917b6236f3a7f02b', '6531cf3421b1265aeeeabaab5e176e6d', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('9d8772c310b675ae43eacdbc6c7fa04a', 'a799c3b1b12dd3ed4bd046bfaef5fe6e', '1663f3faba244d16c94552f849627d84', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('9f8311ecccd44e079723098cf2ffe1cc', '1750a8fb3e6d90cb7957c02de1dc8e59', '693ce69af3432bd00be13c3971a57961', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('a098e2acc3f90316f161f6648d085640', 'ee8626f80f7c2619917b6236f3a7f02b', 'e6bfd1fcabfd7942fdd05f076d1dad38', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('a66feaaf128417ad762e946abccf27ec', 'ee8626f80f7c2619917b6236f3a7f02b', 'c6cf95444d80435eb37b2f9db3971ae6', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('a7ab87eac0f8fafa2efa4b1f9351923f', 'ee8626f80f7c2619917b6236f3a7f02b', 'fedfbf4420536cacc0218557d263dfea', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('abdc324a2df9f13ee6e73d44c6e62bc8', 'ee8626f80f7c2619917b6236f3a7f02b', 'f1cb187abf927c88b89470d08615f5ac', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('aefc8c22e061171806e59cd222f6b7e1', '52b0cf022ac4187b2a70dfa4f8b2d940', 'e8af452d8948ea49d37c934f5100ae6a', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b131ebeafcfd059f3c7e542606ea9ff5', 'ee8626f80f7c2619917b6236f3a7f02b', 'e5973686ed495c379d829ea8b2881fc6', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b2b2dcfff6986d3d7f890ea62d474651', 'ee8626f80f7c2619917b6236f3a7f02b', '200006f0edf145a2b50eacca07585451', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b495a46fa0e0d4637abe0db7fd12fe1a', 'ee8626f80f7c2619917b6236f3a7f02b', '717f6bee46f44a3897eca9abd6e2ec44', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b4d20a9aba4511f0b433aef3b8bf95ae', 'f6817f48af4fb3af11b9e8bf182f618b', '1853002001', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b4d24d48ba4511f0b433aef3b8bf95ae', 'f6817f48af4fb3af11b9e8bf182f618b', '1853002002', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b4d27872ba4511f0b433aef3b8bf95ae', 'f6817f48af4fb3af11b9e8bf182f618b', '1853002003', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b4d2a450ba4511f0b433aef3b8bf95ae', 'f6817f48af4fb3af11b9e8bf182f618b', '1853002004', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b4d34590ba4511f0b433aef3b8bf95ae', 'f6817f48af4fb3af11b9e8bf182f618b', '1853003001', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b4d35c06ba4511f0b433aef3b8bf95ae', 'f6817f48af4fb3af11b9e8bf182f618b', '1853003002', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b4d3ab34ba4511f0b433aef3b8bf95ae', 'f6817f48af4fb3af11b9e8bf182f618b', '1853003003', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b4d3d5beba4511f0b433aef3b8bf95ae', 'f6817f48af4fb3af11b9e8bf182f618b', '1853003004', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('b4d3eebeba4511f0b433aef3b8bf95ae', 'f6817f48af4fb3af11b9e8bf182f618b', '1853004001', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('d37ad568e26f46ed0feca227aa9c2ffa', 'f6817f48af4fb3af11b9e8bf182f618b', '9502685863ab87f0ad1134142788a385', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('d3fe195d59811531c05d31d8436f5c8b', '1750a8fb3e6d90cb7957c02de1dc8e59', 'e8af452d8948ea49d37c934f5100ae6a', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('e258ca8bf7ee168b93bfee739668eb15', 'ee8626f80f7c2619917b6236f3a7f02b', 'fb367426764077dcf94640c843733985', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('e339f7db7418a4fd2bd2c113f1182186', 'ee8626f80f7c2619917b6236f3a7f02b', 'b1cb0a3fedf7ed0e4653cb5a229837ee', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('e3e922673f4289b18366bb51b6200f17', '52b0cf022ac4187b2a70dfa4f8b2d940', '45c966826eeff4c99b8f8ebfe74511fc', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('f17ab8ad1e71341140857ef4914ef297', '21c5a3187763729408b40afb0d0fdfa8', '732d48f8e0abe99fe6a23d18a3171cd1', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('fd86f6b08eb683720ba499f9d9421726', 'ee8626f80f7c2619917b6236f3a7f02b', '693ce69af3432bd00be13c3971a57961', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('fed41a4671285efb266cd404f24dd378', '52b0cf022ac4187b2a70dfa4f8b2d940', '00a2a0ae65cdca5e93209cdbde97cbe6', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('learning_rp_001', 'f6817f48af4fb3af11b9e8bf182f618b', '1853001', NULL, '2025-11-05 00:03:22', NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('learning_rp_002', 'f6817f48af4fb3af11b9e8bf182f618b', '1853002', NULL, '2025-11-05 00:03:22', NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('learning_rp_003', 'f6817f48af4fb3af11b9e8bf182f618b', '1853003', NULL, '2025-11-05 00:03:22', NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('learning_rp_004', 'f6817f48af4fb3af11b9e8bf182f618b', '1853004', NULL, '2025-11-05 00:03:22', NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('place_order_perm_1853006', 'f6817f48af4fb3af11b9e8bf182f618b', '1853006', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('place_order_perm_1853006001', 'f6817f48af4fb3af11b9e8bf182f618b', '1853006001', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('place_order_perm_1853006002', 'f6817f48af4fb3af11b9e8bf182f618b', '1853006002', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('platform_config_perm_1853005', 'f6817f48af4fb3af11b9e8bf182f618b', '1853005', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('platform_config_perm_1853005001', 'f6817f48af4fb3af11b9e8bf182f618b', '1853005001', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('platform_config_perm_1853005002', 'f6817f48af4fb3af11b9e8bf182f618b', '1853005002', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('platform_config_perm_1853005003', 'f6817f48af4fb3af11b9e8bf182f618b', '1853005003', NULL, NULL, NULL);
INSERT INTO `sys_role_permission` (`id`, `role_id`, `permission_id`, `data_rule_ids`, `operate_date`, `operate_ip`) VALUES ('platform_config_perm_1853005004', 'f6817f48af4fb3af11b9e8bf182f618b', '1853005004', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_table_white_list
-- ----------------------------
DROP TABLE IF EXISTS `sys_table_white_list`;
CREATE TABLE `sys_table_white_list` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id',
  `table_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '允许的表名',
  `field_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '允许的字段名，多个用逗号分割',
  `status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '1' COMMENT '状态，1=启用，0=禁用',
  `create_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq_sys_table_white_list_table_name` (`table_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统表白名单';

-- ----------------------------
-- Records of sys_table_white_list
-- ----------------------------
BEGIN;
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1701578033271521282', 'sys_user', 'phone,work_no,id,email,realname,username', '1', 'admin', '2023-09-12 10:46:32', 'admin', '2023-12-31 16:55:30');
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1701581935488385025', 'oa_officialdoc_organcode', 'id,organ_name', '1', 'admin', '2023-09-12 11:02:02', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1701582035472203777', 'sys_permission', 'id,name', '1', 'admin', '2023-09-12 11:02:26', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1701582087619985409', 'onl_drag_comp', 'id,comp_name', '1', 'admin', '2023-09-12 11:02:38', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1701582136420712450', 'sys_depart', 'id,org_code,depart_name', '1', 'admin', '2023-09-12 11:02:50', 'admin', '2023-10-18 09:36:40');
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1701582163599802370', 'design_form', 'id,desform_name,desform_code', '1', 'admin', '2023-09-12 11:02:56', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1701582190187495426', 'onl_cgform_head', 'table_txt,table_name', '1', 'admin', '2023-09-12 11:03:03', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1701582254301626370', 'oa_wps_file', 'id,name', '1', 'admin', '2023-09-12 11:03:18', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1714453996678926338', 'onl_cgreport_head', 'code', '1', 'admin', '2023-10-18 09:31:00', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1714455418728337410', 'sys_category', 'id,name', '1', 'admin', '2023-10-18 09:36:40', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1714471625900564482', 'sys_position', 'name,id', '1', 'ceshi', '2023-10-18 10:41:04', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1769610154632491009', 'sys_dict', 'dict_code', '1', 'admin', '2024-03-18 14:21:53', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1778692300030484482', 'test_shoptype_tree', 'type_name,id', '1', 'admin', '2024-04-12 15:51:05', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1782650226206269441', 'sys_tenant', 'name,id', '1', 'admin', '2024-04-23 13:58:29', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1800712552062898178', 'tj_user_report', 'name,username', '1', 'admin', '2024-06-12 10:11:43', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1801076145102925826', 'sys_data_source', 'code,name', '1', 'admin', '2024-06-13 10:16:30', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1801097090085564420', 'sys_role', 'role_name,role_code', '1', 'jeecg', '2024-06-13 11:39:44', 'admin', '2024-09-10 11:47:35');
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1805416360756006913', 'wu_liao', 'wul_name,id', '1', 'admin', '2024-06-25 09:42:58', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1897919397122269185', 'ces_shop_type', 'name,pid,id,has_child', '1', 'admin', '2025-03-07 15:57:01', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1950438522834546690', 'sys_sms_template', 'template_code', '1', 'admin', '2025-07-30 14:09:16', NULL, NULL);
INSERT INTO `sys_table_white_list` (`id`, `table_name`, `field_name`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1966817706103730178', 'sys_check_rule', 'rule_code', '1', 'admin', '2025-09-13 18:54:17', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_tenant
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant`;
CREATE TABLE `sys_tenant` (
  `id` int NOT NULL COMMENT '租户编码',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '租户名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `begin_date` datetime DEFAULT NULL COMMENT '开始时间',
  `end_date` datetime DEFAULT NULL COMMENT '结束时间',
  `status` int DEFAULT NULL COMMENT '状态 1正常 0冻结',
  `trade` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属行业',
  `company_size` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '公司规模',
  `company_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '公司地址',
  `company_logo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '公司logo',
  `house_number` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '门牌号',
  `work_place` varchar(100) CHARACTER SET utf32 COLLATE utf32_general_ci DEFAULT NULL COMMENT '工作地点',
  `secondary_domain` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '二级域名',
  `login_bkgd_img` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '登录背景图片',
  `position` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '职级',
  `department` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '部门',
  `del_flag` tinyint(1) DEFAULT '0' COMMENT '删除状态(0-正常,1-已删除)',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `apply_status` int DEFAULT NULL COMMENT '允许申请管理员 1允许 0不允许',
  `admin_user_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '站长用户ID',
  `webmaster_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `credential_token` varchar(128) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `credential_expires_at` datetime DEFAULT NULL,
  `activation_code` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_webmaster_code` (`webmaster_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='多租户信息表';

-- ----------------------------
-- Records of sys_tenant
-- ----------------------------
BEGIN;
INSERT INTO `sys_tenant` (`id`, `name`, `create_time`, `create_by`, `begin_date`, `end_date`, `status`, `trade`, `company_size`, `company_address`, `company_logo`, `house_number`, `work_place`, `secondary_domain`, `login_bkgd_img`, `position`, `department`, `del_flag`, `update_by`, `update_time`, `apply_status`, `admin_user_id`, `webmaster_code`, `credential_token`, `credential_expires_at`, `activation_code`) VALUES (1000, '北京国炬信息技术有限公司', '2023-03-09 19:55:11', 'jeecg', NULL, NULL, 1, NULL, NULL, NULL, '', '2PI3U6', NULL, NULL, NULL, NULL, NULL, 0, 'admin', '2023-11-05 10:35:15', NULL, NULL, NULL, NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_tenant_domain
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant_domain`;
CREATE TABLE `sys_tenant_domain` (
  `id` varchar(32) NOT NULL COMMENT '主键ID',
  `tenant_id` int NOT NULL COMMENT '租户ID',
  `domain` varchar(255) NOT NULL COMMENT '自定义域名',
  `status` tinyint DEFAULT '1' COMMENT '状态：1=启用，0=禁用',
  `create_by` varchar(32) DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `ssl_status` varchar(20) DEFAULT 'pending' COMMENT 'SSL证书状态：pending=待申请，issuing=申请中，issued=已颁发，failed=失败',
  `ssl_expire_time` datetime DEFAULT NULL COMMENT 'SSL证书过期时间',
  `ssl_message` varchar(500) DEFAULT NULL COMMENT 'SSL状态消息',
  `cf_hostname_id` varchar(64) DEFAULT NULL COMMENT 'Cloudflare Custom Hostname ID',
  `verify_txt_name` varchar(255) DEFAULT NULL COMMENT '域名所有权验证TXT记录名称',
  `verify_txt_value` varchar(500) DEFAULT NULL COMMENT '域名所有权验证TXT记录值',
  `ssl_txt_name` varchar(255) DEFAULT NULL COMMENT 'SSL证书验证TXT记录名称',
  `ssl_txt_value` varchar(500) DEFAULT NULL COMMENT 'SSL证书验证TXT记录值',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_domain` (`domain`),
  KEY `idx_tenant_id` (`tenant_id`),
  KEY `idx_cf_hostname_id` (`cf_hostname_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户域名绑定表';

-- ----------------------------
-- Records of sys_tenant_domain
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_tenant_pack
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant_pack`;
CREATE TABLE `sys_tenant_pack` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id',
  `tenant_id` int DEFAULT NULL COMMENT '租户id',
  `pack_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '产品包名',
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开启状态(0 未开启 1开启)',
  `remarks` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` date DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` date DEFAULT NULL COMMENT '更新时间',
  `pack_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编码,默认添加的三个管理员需要设置编码',
  `pack_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'custom' COMMENT '产品包类型(default 默认产品包 custom 自定义产品包)',
  `iz_sysn` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '自动分配给用户(0否 1是)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx__stp_tenant_id_pack_code` (`tenant_id`,`pack_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='租户产品包';

-- ----------------------------
-- Records of sys_tenant_pack
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_tenant_pack_perms
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant_pack_perms`;
CREATE TABLE `sys_tenant_pack_perms` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键编号',
  `pack_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '租户产品包名称',
  `permission_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '菜单id',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` date DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` date DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_stpp_pack_id` (`pack_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='租户产品包和菜单关系表';

-- ----------------------------
-- Records of sys_tenant_pack_perms
-- ----------------------------
BEGIN;
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955183422662197249', '1714517098074152962', '1438108225451974658', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955184115389251585', '1955184115322142722', '1438108225451974658', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955187901482614785', '1955187901394534401', '1438108176273760258', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955187901503586305', '1955187901394534401', '1438108176814825473', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955187901516169218', '1955187901394534401', '1620709334357532673', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955187901528752129', '1955187901394534401', '9502685863ab87f0ad1134142788a385', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955195388533358593', '1955187901394534401', '1438108187455774722', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955195388600467458', '1955187901394534401', '1438108178911977473', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955195388659187713', '1955187901394534401', '1438108183395688450', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955195509216067585', '1955187901394534401', '1439398677984878593', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955195509216067586', '1955187901394534401', '1438108225451974658', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955195623284359170', '1955187901394534401', '1443390062919208961', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955195663855861761', '1955187901394534401', '1438108183492157442', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955195717383569409', '1955187901394534401', '119213522910765570', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955221560482840577', '1714517098074152962', '1438108176273760258', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955221560617058305', '1714517098074152962', '9502685863ab87f0ad1134142788a385', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955221560617058306', '1714517098074152962', '1620709334357532673', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955221560617058307', '1714517098074152962', '1438108176814825473', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955222179079766017', '1714517098074152962', '1438108187455774722', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955222179146874881', '1714517098074152962', '1438108178911977473', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955222289125720067', '1955222289125720066', '1438108225451974658', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955222289125720068', '1955222289125720066', '1438108176273760258', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955222289125720069', '1955222289125720066', '9502685863ab87f0ad1134142788a385', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955222289125720070', '1955222289125720066', '1620709334357532673', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955222289125720071', '1955222289125720066', '1438108176814825473', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955222289188634625', '1955222289125720066', '1438108187455774722', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('1955222289188634626', '1955222289125720066', '1438108178911977473', 'admin', '2025-08-12', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004837041346609154', '2004837040717463554', '1438108225451974658', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004837041791205377', '2004837040717463554', '1438108176273760258', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004837042219024386', '2004837040717463554', '9502685863ab87f0ad1134142788a385', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004837042651037698', '2004837040717463554', '1620709334357532673', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004837043087245314', '2004837040717463554', '1438108176814825473', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004837043515064321', '2004837040717463554', '1438108187455774722', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004837044039352322', '2004837040717463554', '1438108178911977473', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004842014453149697', '2004842013798838273', '1438108225451974658', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004842014893551617', '2004842013798838273', '1438108176273760258', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004842015317176321', '2004842013798838273', '9502685863ab87f0ad1134142788a385', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004842015749189634', '2004842013798838273', '1620709334357532673', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004842016177008641', '2004842013798838273', '1438108176814825473', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004842016634187778', '2004842013798838273', '1438108187455774722', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004842017087172609', '2004842013798838273', '1438108178911977473', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004844344649097217', '2004844344007368705', '1438108225451974658', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004844345076916225', '2004844344007368705', '1438108176273760258', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004844345513123842', '2004844344007368705', '9502685863ab87f0ad1134142788a385', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004844345949331458', '2004844344007368705', '1620709334357532673', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004844346364567553', '2004844344007368705', '1438108176814825473', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004844346809163778', '2004844344007368705', '1438108187455774722', 'admin', '2025-12-27', NULL, NULL);
INSERT INTO `sys_tenant_pack_perms` (`id`, `pack_id`, `permission_id`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004844347249565697', '2004844344007368705', '1438108178911977473', 'admin', '2025-12-27', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_tenant_pack_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant_pack_user`;
CREATE TABLE `sys_tenant_pack_user` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `pack_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '租户产品包ID',
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户ID',
  `tenant_id` int DEFAULT NULL COMMENT '租户ID',
  `create_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `status` int DEFAULT NULL COMMENT '状态 正常状态1 申请状态0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_tpu_pack_id` (`pack_id`) USING BTREE,
  KEY `idx_tpu_user_id` (`user_id`) USING BTREE,
  KEY `idx_tpu_tenant_id` (`tenant_id`) USING BTREE,
  KEY `idx_tpu_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='租户套餐人员表';

-- ----------------------------
-- Records of sys_tenant_pack_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_tenant_pack_user` (`id`, `pack_id`, `user_id`, `tenant_id`, `create_by`, `create_time`, `update_by`, `update_time`, `status`) VALUES ('1633795234318729217', '1633795213938606082', 'a75d45a015c44384a04449ee80dc3503', 1, 'admin', '2023-03-09 19:41:53', NULL, NULL, 1);
INSERT INTO `sys_tenant_pack_user` (`id`, `pack_id`, `user_id`, `tenant_id`, `create_by`, `create_time`, `update_by`, `update_time`, `status`) VALUES ('1955184602037567490', '1955184115322142722', '1955183658394664962', 1000, 'admin', '2025-08-12 16:28:29', NULL, NULL, 1);
INSERT INTO `sys_tenant_pack_user` (`id`, `pack_id`, `user_id`, `tenant_id`, `create_by`, `create_time`, `update_by`, `update_time`, `status`) VALUES ('1955187972634787841', '1955187901394534401', '1955183658394664962', 1000, 'admin', '2025-08-12 16:41:53', NULL, NULL, 1);
INSERT INTO `sys_tenant_pack_user` (`id`, `pack_id`, `user_id`, `tenant_id`, `create_by`, `create_time`, `update_by`, `update_time`, `status`) VALUES ('1955222312760623107', '1955222289125720066', '1955218082645544962', 1001, 'admin', '2025-08-12 18:58:20', NULL, NULL, 1);
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键id',
  `username` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '登录账号',
  `realname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '真实姓名',
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '密码',
  `salt` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'md5密码盐',
  `avatar` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '头像',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `sex` tinyint(1) DEFAULT NULL COMMENT '性别(0-默认未知,1-男,2-女)',
  `email` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '电子邮件',
  `phone` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '电话',
  `org_code` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '登录会话的机构编码',
  `status` tinyint(1) DEFAULT NULL COMMENT '性别(1-正常,2-冻结)',
  `del_flag` tinyint(1) DEFAULT NULL COMMENT '删除状态(0-正常,1-已删除)',
  `activiti_sync` tinyint(1) DEFAULT NULL COMMENT '同步工作流引擎(1-同步,0-不同步)',
  `work_no` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '工号，唯一键',
  `telephone` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '座机号',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `user_identity` tinyint(1) DEFAULT NULL COMMENT '身份（1普通成员 2上级）',
  `depart_ids` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '负责部门',
  `client_id` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '设备ID',
  `login_tenant_id` int DEFAULT NULL COMMENT '上次登录选择租户ID',
  `bpm_status` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '流程入职离职状态',
  `sign_enable` tinyint(1) DEFAULT NULL COMMENT '是否启用个性签名（0 否 1是）',
  `sign` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '个性签名',
  `main_dep_post_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '主岗位（部门岗位id）',
  `position_type` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '职务(字典)',
  `business_id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '业务用户ID(5位起始自增)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_business_id` (`business_id`),
  UNIQUE KEY `uniq_sys_user_work_no` (`work_no`) USING BTREE,
  UNIQUE KEY `uniq_sys_user_username` (`username`) USING BTREE,
  UNIQUE KEY `uniq_sys_user_phone` (`phone`) USING BTREE,
  UNIQUE KEY `uniq_sys_user_email` (`email`) USING BTREE,
  KEY `idx_su_status` (`status`) USING BTREE,
  KEY `idx_su_del_flag` (`del_flag`) USING BTREE,
  KEY `idx_su_del_username` (`username`,`del_flag`) USING BTREE,
  KEY `idx_su_main_dep_post_id` (`main_dep_post_id`) USING BTREE,
  KEY `idx_user_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=10021 DEFAULT CHARSET=utf8mb3 COMMENT='用户表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` (`id`, `username`, `realname`, `password`, `salt`, `avatar`, `birthday`, `sex`, `email`, `phone`, `org_code`, `status`, `del_flag`, `activiti_sync`, `work_no`, `telephone`, `create_by`, `create_time`, `update_by`, `update_time`, `user_identity`, `depart_ids`, `client_id`, `login_tenant_id`, `bpm_status`, `sign_enable`, `sign`, `main_dep_post_id`, `position_type`, `business_id`) VALUES ('2004844341402705921', 'z1238989819283', 'Scott', '1dfc13b6d6bd941596b88258205d7cad', 'JHOPIEMK', NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, 'admin', '2025-12-27 17:18:34', NULL, NULL, NULL, NULL, NULL, 1417846786, NULL, NULL, NULL, NULL, NULL, 10017);
INSERT INTO `sys_user` (`id`, `username`, `realname`, `password`, `salt`, `avatar`, `birthday`, `sex`, `email`, `phone`, `org_code`, `status`, `del_flag`, `activiti_sync`, `work_no`, `telephone`, `create_by`, `create_time`, `update_by`, `update_time`, `user_identity`, `depart_ids`, `client_id`, `login_tenant_id`, `bpm_status`, `sign_enable`, `sign`, `main_dep_post_id`, `position_type`, `business_id`) VALUES ('2004900094320099329', 'zhizun2', '至尊2', 'a362049ae396b004', 'NmfqYT9j', NULL, NULL, NULL, NULL, '15075315958', NULL, 1, 0, NULL, NULL, NULL, 'admin', '2025-12-27 21:00:06', NULL, NULL, NULL, NULL, NULL, 1738063874, NULL, NULL, NULL, NULL, NULL, 10018);
INSERT INTO `sys_user` (`id`, `username`, `realname`, `password`, `salt`, `avatar`, `birthday`, `sex`, `email`, `phone`, `org_code`, `status`, `del_flag`, `activiti_sync`, `work_no`, `telephone`, `create_by`, `create_time`, `update_by`, `update_time`, `user_identity`, `depart_ids`, `client_id`, `login_tenant_id`, `bpm_status`, `sign_enable`, `sign`, `main_dep_post_id`, `position_type`, `business_id`) VALUES ('2004907905783533569', 'zhizun3', '至尊3', 'f407bd0a897ec5c1', 'dXrWsKjr', NULL, NULL, NULL, NULL, '15075315954', NULL, 1, 0, NULL, NULL, NULL, 'admin', '2025-12-27 21:31:09', 'admin', '2025-12-27 21:35:39', NULL, NULL, NULL, 647598081, NULL, NULL, NULL, NULL, NULL, 10019);
INSERT INTO `sys_user` (`id`, `username`, `realname`, `password`, `salt`, `avatar`, `birthday`, `sex`, `email`, `phone`, `org_code`, `status`, `del_flag`, `activiti_sync`, `work_no`, `telephone`, `create_by`, `create_time`, `update_by`, `update_time`, `user_identity`, `depart_ids`, `client_id`, `login_tenant_id`, `bpm_status`, `sign_enable`, `sign`, `main_dep_post_id`, `position_type`, `business_id`) VALUES ('2006015220372803585', 'superAdmin', '超级开发', '348a2021c8f73b12eae45561a63415b4', 'uDiXDqVq', NULL, NULL, NULL, NULL, '13000000000', NULL, 1, 0, NULL, NULL, NULL, 'admin', '2025-12-30 22:51:13', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 10020);
INSERT INTO `sys_user` (`id`, `username`, `realname`, `password`, `salt`, `avatar`, `birthday`, `sex`, `email`, `phone`, `org_code`, `status`, `del_flag`, `activiti_sync`, `work_no`, `telephone`, `create_by`, `create_time`, `update_by`, `update_time`, `user_identity`, `depart_ids`, `client_id`, `login_tenant_id`, `bpm_status`, `sign_enable`, `sign`, `main_dep_post_id`, `position_type`, `business_id`) VALUES ('e9ca23d68d884d4ebb19d07889727dae', 'admin', '管理员', '4035d592c239976e', 'RCGTeGiH', NULL, '1986-02-01', 1, 'admin@jeecg.com', '18611111111', 'A01', 1, 0, NULL, '00001', NULL, NULL, '2025-11-04 19:47:01', 'admin', '2025-11-12 22:00:02', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, 999);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '主键id',
  `user_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '用户id',
  `role_id` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '角色id',
  `tenant_id` int DEFAULT '0' COMMENT '租户ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sur_user_id` (`user_id`) USING BTREE,
  KEY `idx_sur_role_id` (`role_id`) USING BTREE,
  KEY `idx_sur_user_role_id` (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='用户角色表';

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988236256880828417', '1988234839784890369', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988575893312303106', '1988575893295525890', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988581948501499906', 'e9ca23d68d884d4ebb19d07889727dae', 'f6817f48af4fb3af11b9e8bf182f618b', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988602460818239489', '1988602460793073665', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988984239269961729', '1988984239257378818', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988984355330547713', '1988984355309576194', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988984512839245825', '1988984512830857217', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988984663733526530', '1988984663725137921', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988984732163596289', '1988984732159401985', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988984924728287233', '1988984924715704321', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988985188973633538', '1988985188952662017', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988985584207093761', '1988985584198705153', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988985739652194305', '1988985739643805697', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988985795134447617', '1988985795121864705', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988986021895299074', '1988986021886910466', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988986915135250434', '1988986915126861825', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988987148204335105', '1988987148195946498', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988987302345007105', '1988987302324035585', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988987427846971393', '1988987427838582786', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988987729715224577', '1988987729706835970', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988988243177725953', '1988988243169337345', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988988348043714561', '1988988348031131650', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988988549747793922', '1988988549739405313', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988988752374620162', '1988988752366231553', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988989150560870401', '1988989150556676097', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988989813718081538', '1988989813709692930', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988990067813212161', '1988990067804823554', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988990547431874561', '1988990547427680257', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988990841033154561', '1988990841020571649', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988991127080493058', '1988991127076298753', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1988992058689937409', '1988992058685743106', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1989047141448396801', '1989047141410648066', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1989129210136473602', '1989129210119696385', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1989139900863721473', '1989139900846944257', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1989144151547555841', '1989144151539167233', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1989147336970448897', '1989147336957865986', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1989182581774069761', '1989182581685989378', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1989334726427127809', '1989334726406156290', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1998004704805871617', '1998004704738762754', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1998014582853160962', '1998014582794440706', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1999305727785193473', '1999305727743250433', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('1999308820530835458', '1999308820480503810', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2004177742955397121', '2004175283805601793', '092e7af7e18e11f08076525400e87d0c', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2004199413888106498', '2004199413846163457', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2004202055095844866', '2004202055049707522', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2004204683208949762', '2004204683154423809', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2004206107745632258', '2004206107682717697', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2004733138770087938', '2004195046300663809', '1988235440530857986', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2004738190628950018', '2004738190448594945', '092e7af7e18e11f08076525400e87d0c', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2004844342900072450', '2004844341402705921', '092e7af7e18e11f08076525400e87d0c', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2004900094521425921', '2004900094320099329', '092e7af7e18e11f08076525400e87d0c', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2004907905993248770', '2004907905783533569', '092e7af7e18e11f08076525400e87d0c', 0);
INSERT INTO `sys_user_role` (`id`, `user_id`, `role_id`, `tenant_id`) VALUES ('2006015220427329537', '2006015220372803585', '2006015005280505857', 0);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_tenant
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_tenant`;
CREATE TABLE `sys_user_tenant` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id',
  `user_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户id',
  `tenant_id` int DEFAULT NULL COMMENT '租户id',
  `status` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态(1 正常 2 离职 3 待审核 4 拒绝 5 邀请加入)',
  `create_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '创建人登录名称',
  `create_time` datetime DEFAULT NULL COMMENT '创建日期',
  `update_by` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '更新人登录名称',
  `update_time` datetime DEFAULT NULL COMMENT '更新日期',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sut_user_id` (`user_id`) USING BTREE,
  KEY `idx_sut_tenant_id` (`tenant_id`) USING BTREE,
  KEY `idx_sut_user_rel_tenant` (`user_id`,`tenant_id`) USING BTREE,
  KEY `idx_sut_status` (`status`) USING BTREE,
  KEY `idx_sut_userid_status` (`user_id`,`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户租户关系表';

-- ----------------------------
-- Records of sys_user_tenant
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_tenant` (`id`, `user_id`, `tenant_id`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('2004206107846295553', '2004206107682717697', 1222230017, '1', NULL, '2025-12-25 23:02:27', NULL, NULL);
INSERT INTO `sys_user_tenant` (`id`, `user_id`, `tenant_id`, `status`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES ('8f0dd853e19311f08076525400e87d0c', '2004175283805601793', 1222230017, '1', NULL, '2025-12-25 21:13:52', NULL, NULL);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
