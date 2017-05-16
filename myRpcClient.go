package main

import (
	"ethos/altEthos"
	"ethos/syscall"
	"ethos/log"
)

var logger = log.Initialize("test/myRpcClient/")

func init() {

	SetupMyRpcIncrementReply(incrementReply)

}

func incrementReply(count uint64) (MyRpcProcedure) {
	logger.Printf("myRpcClient: Received Increment Reply: %v\n", count)
	return nil
}


func main () {

	logger.Printf("myRpcClient: before call\n")

	fd, status := altEthos.IpcRepeat("myRpcClient", "", nil)
	if status != syscall.StatusOk {
		logger.Printf("Ipc failed: %v\n", status)
		altEthos.Exit(status)
	}

	call := MyRpcIncrement{}
	status = altEthos.ClientCall(fd, &call)
	if status != syscall.StatusOk {
		logger.Printf("clientCall failed: %v\n", status)
		altEthos.Exit(status)
	}

	logger.Printf("myRpcClient: done\n")
}
