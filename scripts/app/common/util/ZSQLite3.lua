--[[--------------------------
[SQL]SQL数据库  

 	Copyright (c) 2011-2017 Baby-Bus.com

	- Desc: 	SQL数据库
	- Author: 	zengbinsi
	- Date: 	2017-01-20  

--]]--------------------------  







local M = class("ZSQLite3")

---
-- 实例对象
---
M.instance 		= nil 


local sqlite3 	= require("lsqlite3")


--[[-
获取数据库单例  

<br/>  
### Useage:
  	获取一个数据库操作对象。  

### Notice:
	注意   

### Example:
	示例  

### Returns: 
-   ZSQLite3  

--]]
function M.getInstance()
 	if not M.instance then 
 		M.instance = M.new({})
 	end

 	return M.instance  
end





--[[-
构造方法  

<br/>  
### Useage:
  	创建一个对象。  

--]]
function M:ctor(params)
 	params 	= params or {}


 	if not self.db then 
 		self:createDataBase()
 	end
end










--========================
--  功能方法
--========================

--[[-
创建数据库  

<br/>  
### Useage:
  	创建一个数据库文件。  

### Notice:
	注意   

### Example:
	示例  

### Parameters:
- 	类型 	**参数名** 				[必/可选] 参数说明  

### OptionParameters
	其它参数  

### Returns: 
-   返回值类型 							返回值说明  

--]]
function M:createDataBase()
 	-- local dbFilePath 	= device.writablePath .. "zbs/wldata/db/wldb.db"
 	-- local db 			= sqlite3.open(dbFilePath)
 	-- self.db 				= db 

 	-- dump(self.db)

	local db 	= sqlite3.open_memory()
	self.db 	= db 

	return db 

	-- db:exec[[
	--   CREATE TABLE test (id INTEGER PRIMARY KEY, content);

	--   INSERT INTO test VALUES (NULL, 'Hello World');
	--   INSERT INTO test VALUES (NULL, 'Hello Lua');
	--   INSERT INTO test VALUES (NULL, 'Hello Sqlite3')
	-- ]]

	-- for row in db:nrows("SELECT * FROM test") do
	--     print(row.id, row.content)
	-- end
end  

--[[-
执行SQL命令  

<br/>  
### Useage:
  	执行一条非查询的SQL命令。  

### Notice:
	注意   

### Example:
	
	-- local sql3 			= c.ZSQLite3.getInstance()
	-- -- create table 
	-- local sqlString	 	= [ [
	--   CREATE TABLE test2 (id INTEGER PRIMARY KEY, content);

	--   INSERT INTO test2 VALUES (NULL, 'Hello World');
	--   INSERT INTO test2 VALUES (NULL, 'Hello Lua');
	--   INSERT INTO test2 VALUES (NULL, 'Hello Sqlite3')
	-- ] ]
	-- sql3:execNoQuery(sqlString)
	-- -- select 
	-- dump(sql3:execQuery("SELECT * FROM test2"))


	-- -- insert
	-- sql3:execNoQuery("insert into test2 (id, content) values (5, 'hello babybus')")
	-- dump(sql3:execQuery("SELECT * FROM test2"))

	-- sql3:execNoQuery("insert into test2 (content) values ('hello babybus2')")
	-- dump(sql3:execQuery("SELECT * FROM test2"))


	-- -- update
	-- sql3:execNoQuery("update test2 set content = 'Hello Lua sqlite3'")
	-- dump(sql3:execQuery("SELECT * FROM test2"))

	-- -- update where
	-- sql3:execNoQuery("update test2 set content = 'aaaa' where id = 2")
	-- dump(sql3:execQuery("SELECT * FROM test2"))

	-- -- select order by 
	-- dump(sql3:execQuery("select * from test2 order by id desc"))

	-- -- select where 
	-- dump(sql3:execQuery("select * from test2 where id > 1"))

	-- -- select like 
	-- dump(sql3:execQuery("select * from test2 where content like '%li%3'"))

	-- -- delete 
	-- dump(sql3:execQuery("delete from test2 where id = 1"))


	-- do return end 	  

### Parameters:
- 	stirng 	**sqlString** 				[必选] SQL命令  

### Returns: 
-   返回值类型 							返回值说明  

--]]
function M:execNoQuery(sqlString)
 	return self.db:exec(sqlString)
end

--[[-
执行SQL命令  

<br/>  
### Useage:
  	执行一条查询的SQL命令。  

### Notice:
	注意   

### Example:
	示例  

### Parameters:
- 	stirng 	**sqlString** 				[必选] SQL命令  

### Returns: 
-   table  

--]]
function M:execQuery(sqlString)
	local dataTable 	= {}  

 	for row in self.db:nrows(sqlString) do
	    table.insert(dataTable, row)
	end

	return dataTable
end









return M 



