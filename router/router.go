package router

import "github.com/gin-gonic/gin"

/*
 * 配置APP的路由组
 * APP的接口使用定义 使用 /版本号/资源名/操作， 例如 /v1/task/create
 * 路由组分为2大类， 一类是业务API； 一类是管理API， 管理API不需要登录认证等信息； 业务API除了一些配置同步和登录接口外，都需要认证和鉴权
 * 所以，基本的路由组划分为：
 * 业务API：
 *  版本号1（带登录认证的）
		资源
	版本号2（带登录认证的）
		资源
	版本号n（带登录认证的）
	config (不带登录认证的)
	管理等 （不带登录认证的）
*/

// 路由整体的初始化入口
func InitRouter(r *gin.Engine) {
	initV1Group(r)
	initNoLoginGroup(r)
	initAdminGroup(r)
}

// 初始化业务V1版本接口的路由组
func initV1Group(r *gin.Engine) {
	// 路由组变量定义
	ping := r.Group("/v1")
	// 路由组中间件
	ping.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
}

// 初始化业务非登录接口的路由组
func initNoLoginGroup(r *gin.Engine) {

}

// 初始化管理接口路由组
func initAdminGroup(r *gin.Engine) {

}
