/*package com.org.twopm.websocket;

import java.util.HashSet;
import java.util.Set;

import javax.websocket.Endpoint;
import javax.websocket.server.ServerApplicationConfig;
import javax.websocket.server.ServerEndpointConfig;

public class WebSocketConfig implements ServerApplicationConfig{

	@Override
	public Set<Class<?>> getAnnotatedEndpointClasses(Set<Class<?>> scanned) {
		// TODO Auto-generated method stub
		System.out.println("******getAnnotatedEndpointClasses******");
		// Deploy all WebSocket endpoints defined by annotations in the examples
        // web application. Filter out all others to avoid issues when running
        // tests on Gump
		//This is mainly to scan type bag, if the prefix is " com.websocket." he seized her, and then do what, you'll see
		Set<Class<?>> res=new HashSet<>();
		for(Class<?> cs:scanned){
			if(cs.getPackage().getName().startsWith("com.websocket.")){
				res.add(cs);
			}
		}
		return res;
	}

	@Override
	public Set<ServerEndpointConfig> getEndpointConfigs(
			Set<Class<? extends Endpoint>> scanned) {
		// TODO Auto-generated method stub
		System.out.println("******getEndpointConfigs******");
		Set<ServerEndpointConfig> res=new HashSet<>();
		
	   //UseProgrammatic API server address

		if (scanned.contains(EchoEndpoint.class)) {
            res.add(ServerEndpointConfig.Builder.create(
                    EchoEndpoint.class,
                    "/websocket/echoProgrammatic").build());
        }
        
		return res;
	}

}
*/