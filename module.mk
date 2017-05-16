test.test.myRpcClient         = myRpcClient
test.test.myRpcClient.dir     = test/test/myRpcClient
test.test.myRpcClient.build   = $(UDIR)/$(test.test.myRpcClient.dir)
test.test.myRpcClient.target  = $(test.test.myRpcClient.build)/myRpcClient \
                            $(test.test.myRpcClient.build)/myRpcService
test.test.myRpcClient.client.root  = $(test.test.myRpcClient.build)/client/rootfs

test.test.myRpcClient.myRpcClient.src = $(test.test.myRpcClient.dir)/myRpcClient.go\
	 $(test.test.myRpcClient.dir)/myRpc.go
test.test.myRpcClient.myRpcService.src = $(test.test.myRpcClient.dir)/myRpcService.go\
	 $(test.test.myRpcClient.dir)/myRpc.go

$(test.test.myRpcClient.dir)/myRpc.go: $(test.test.myRpcClient.dir)/myRpc.t
	$(ETN2GO) . $(test.test.myRpcClient.dir)/myRpc main $^

test.test.myRpcClient.run:
	test/scripts/testRun $(UDIR) $(test.test.myRpcClient.dir) client

test.test.myRpcClient.check:
	@test/scripts/testCheck $(UDIR) $(test.test.myRpcClient.dir) client

test.test.myRpcClient.build:  $(test.test.myRpcClient.target)
	test/scripts/testBuilder $(UDIR) $(test.test.myRpcClient.dir) client client  myRpc/MyRpc 
	cp $(test.test.myRpcClient.build)/myRpcService $(test.test.myRpcClient.client.root)/programs
	ethosStringEncode /programs/myRpcService    > $(test.test.myRpcClient.client.root)/etc/init/services/myRpcService

$(test.test.myRpcClient.build)/myRpcService: $(test.test.myRpcClient.myRpcService.src)
	ethosGo $^ 

$(test.test.myRpcClient.build)/myRpcClient: $(test.test.myRpcClient.myRpcClient.src)
	ethosGo $^ 

test.test.myRpcClient.client.tar:
	tar cvf $(test.test.myRpcClient.dir)/directories-client.tar -C $(UDIR)/$(test.test.myRpcClient.dir)/client logReference directoryInitialize directoryReference

