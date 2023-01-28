package main

import (
	"github.com/gin-gonic/gin"
	"github.com/kstrwind/Reminder/router"
	"log"
)

func main() {
	r := gin.Default()

	// 全局使用中间件初始化
	// 日志中间件初始化
	InitLogger(r)
	// recovery 中间件
	r.Use(gin.Recovery())

	router.InitRouter(r)

	r.Run(":9090")
}

func InitLogger(r *gin.Engine) {
	r.Use(gin.Logger())
	// 配置日志格式
	gin.DebugPrintRouteFunc = func(httpMethod, absolutePath, handlerName string, nuHandlers int) {
		log.Printf("endpoint %v %v %v %v\n", httpMethod, absolutePath, handlerName, nuHandlers)
	}
}
