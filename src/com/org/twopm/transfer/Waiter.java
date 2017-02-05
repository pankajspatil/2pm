package com.org.twopm.transfer;

public class Waiter {

	String waiterName;
	Integer waiterId;

	public String getWaiterName() {
		return waiterName;
	}

	public void setWaiterName(String waiterName) {
		this.waiterName = waiterName;
	}

	public Integer getWaiterId() {
		return waiterId;
	}

	public void setWaiterId(Integer waiterId) {
		this.waiterId = waiterId;
	}

	@Override
	public String toString() {
		return "Waiter [waiterName=" + waiterName + ", waiterId=" + waiterId
				+ "]";
	}
}
