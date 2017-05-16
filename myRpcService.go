package main

import (
	"ethos/syscall"
	"ethos/altEthos"
	"ethos/log"
)

var myRpc_increment_counter uint64 = 0
var logger = log.Initialize("test/myRpcClient/")

func init() {

	SetupMyRpcIncrement(increment)
}

func increment() (MyRpcProcedure) {
	logger.Printf("myRpcService: called increment\n")
	myRpc_increment_counter++
	return &MyRpcIncrementReply{myRpc_increment_counter}
}

func main () {

	listeningFd, status := altEthos.Advertise("myRpcClient")
	if status != syscall.StatusOk {
		logger.Printf("Advertising service failed: %s\n", status)
		altEthos.Exit(status)
	}

	for {
		_, fd, status := altEthos.Import(listeningFd)
		if status != syscall.StatusOk {
			logger.Printf("Error calling Import: %v\n", status)
			altEthos.Exit(status)
		}

		logger.Printf("myRpcService: new connection accepted\n")

		t := MyRpc{}
		altEthos.Handle(fd, &t)
	}

}
