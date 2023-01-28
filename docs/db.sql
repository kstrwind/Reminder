create database reminder;
use reminder;
create table r_task
(
    uid         bigint       default 0  not null comment '用户ID',
    t_id        bigint       default 0  not null comment 'task id, 用于做到全局唯一，这里用毫秒级时间戳来表示，可以做到全局唯一，方便后续做数据清理和恢复
毫秒级时间戳，能满足人工操作的时间精度，机器操作的话，出现冲突就冲突了',
    name        varchar(128) default '' not null comment '任务名',
    description varchar(512) default '' not null comment '任务的备注',
    status      int          default 1  not null comment '任务状态机',
    priority    tinyint      default 1  not null comment '任务优先级',
    ctime       int unsigned default 0  not null comment '任务创建的时间，用秒级时间戳表示， 当前uint32 可以表征到 2106年，还有80年左右的时间，够用',
    etime       int unsigned default 0  not null comment '任务计划的截止完成时间',
    tag         varchar(256) default '' not null comment '任务的tag标签， json串， 可以打多个，但是还是限制下只能打10个',
    group_id    int unsigned default 0  not null comment '任务分组ID',
    cost_time   int          default 0  not null comment '任务实际耗时，秒级',
    constraint r_task_pk
        primary key (uid, t_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    comment '任务表，定期清理归档的任务，或者后期按照用户UID来做hash';

create index r_task_group_id__index
    on r_task (group_id);

create index r_task_status_index
    on r_task (status);


create table t_user
(
    uid                bigint       auto_increment comment '用户ID,自增',
    name               varchar(128) default '' not null comment '用户名,用于显示',
    mobile_zone_number varchar(8)   default '' not null comment '手机号区号',
    mobile             bigint       default 0  not null comment '手机号， 只能绑定一个
用户用于找回密码的方式单独写一张表',
    wechat_id          bigint       default 0  null comment '用户使用微信登录时，记录微信的ID',
    zfb_id             bigint       default 0  not null comment '用户来自支付宝登录时，支付宝ID',
    mail               varchar(128) default '' not null comment '用户绑定邮箱，可以用于登录',
    icon               varchar(256) default '' not null comment '用户头像地址',
    constraint t_user_pk
        primary key (uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '用户信息表';

create table r_task_group
(
    gid        bigint auto_increment comment '任务的group id, 全局唯一',
    name       varchar(128) default '' not null comment '组名',
    status     int          default 1  not null comment '分组状态',
    ctime      int unsigned default 0  not null comment '分组创建的时间戳',
    `order`    tinyint      default 1  not null comment '分组内部任务排序规则',
    ctr_bit    int unsigned default 0  not null comment '控制字段，按照bit位来分配：
0， 无控制逻辑
1， 完成后隐藏',
    p_group_id bigint       default 0  null comment '父分组ID， 0表示自己为根分组',
    group_path varchar(128) default '' not null comment '分组绝对路径，用于2个作用：
1. 优化多层路径的显示性能
2. 控制分组嵌套的层次',
    constraint r_task_group_pk
        primary key (gid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    comment '任务分组，可以作为清单的概念，分组可嵌套';