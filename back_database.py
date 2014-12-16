#!/usr/bin/env python
#-*- coding:utf-8 -*-


import MySQLdb
import MySQLdb as Database
import time
import sys 
import math
reload(sys)
sys.getdefaultencoding()

#获取一天前时间
date_time = time.strftime('%Y%m%d',time.localtime(time.time()))

'''创建临时表~~~'''
table_name_a = 'ACCESS_COUNT_IPA%s' %(date_time)
table_name_b = 'ACCESS_COUNT_IPB%s' %(date_time)
table_name_c = 'ACCESS_COUNT_IPC%s' %(date_time)

table_a = 'ACCESS_COUNT_IPA'
table_b = 'ACCESS_COUNT_IPB'
table_c = 'ACCESS_COUNT_IPC'

def get_time(format):
        time_span= 1440
        get_time = int(time.time())
        current_time = int(get_time/60) * 60 -60 * time_span
        format = str(current_time) + "000"
        return format


def db_connect(is_true):
    connect_mysql = MySQLdb.connect(host='',user='',passwd='',db='',port=3306)
    return connect_mysql


def create_table(is_true):
        is_connect = db_connect(True)
        curr = is_connect.cursor()
        for table_name in table_name_a,table_name_b,table_name_c:
            create_table = '''CREATE TABLE `%s` (
            `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增ID',
            `TIME` mediumtext NOT NULL COMMENT '统计时间，精确到分钟',
            `ip` int(10) unsigned NOT NULL COMMENT 'C类IP的整型值',
            `ACCESS_COUNT` int(10) unsigned NOT NULL COMMENT '访问数量',
             PRIMARY KEY (`ID`),
             KEY `TIME_index` (`TIME`(13))
             ) ENGINE=InnoDB''' %(table_name)
            c_table = curr.execute(create_table)
            if int(c_table) == 0:
                print "成功创建表 %s" %(table_name)
            else:
                return False
    

def copy_ipa():
        is_connect = db_connect(True)
        curr = is_connect.cursor()
        time = get_time(format)
        sql = "select TIME,AIP,ACCESS_COUNT from %s where TIME >= %s" %(table_a,time)
        get_sql = curr.execute(sql)
        if int(get_sql) != 0:
            row = curr.fetchall()
            for row1 in row:
                format_time = row1[0]
                CIP = row1[1]
                COUNT = row1[2]
                execute_data = "insert into %s (`TIME`,`ip`,`ACCESS_COUNT`) values ('%s','%s','%s')" %(table_name_a,format_time,CIP,COUNT)
                execute_sql = curr.execute(execute_data)
                is_connect.commit()


def copy_ipb():
        is_connect = db_connect(True)
        curr = is_connect.cursor()
        time = get_time(format)
        sql = "select TIME,BIP,ACCESS_COUNT from %s where TIME >= %s" %(table_b,time)
        get_sql = curr.execute(sql)
        if int(get_sql) != 0:
            row = curr.fetchall()
            for row1 in row:
                format_time = row1[0]
                CIP = row1[1]
                COUNT = row1[2]
                execute_data = "insert into %s (`TIME`,`ip`,`ACCESS_COUNT`) values ('%s','%s','%s')" %(table_name_b,format_time,CIP,COUNT)
                execute_sql = curr.execute(execute_data)
                is_connect.commit()

def copy_ipc():
        is_connect = db_connect(True)
        curr = is_connect.cursor()
        time = get_time(format)
        sql = "select TIME,CIP,ACCESS_COUNT from %s where TIME >= %s" %(table_c,time)
        get_sql = curr.execute(sql)
        if int(get_sql) != 0:
            row = curr.fetchall()
            for row1 in row:
                format_time = row1[0]
                CIP = row1[1]
                COUNT = row1[2]
                execute_data = "insert into %s (`TIME`,`ip`,`ACCESS_COUNT`) values ('%s','%s','%s')" %(table_name_c,format_time,CIP,COUNT)
                execute_sql = curr.execute(execute_data)
                is_connect.commit()

if __name__ == '__main__':
    create_table = create_table(True)
    print "|--------------------"
    print "插入A段数据库。。    |" 
    copy_ipa() 
    print "插入B段数据库"
    copy_ipb()
    print "插入C段数据库"
    copy_ipc()
    print "|--------------------|"
