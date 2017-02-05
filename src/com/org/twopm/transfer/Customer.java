package com.org.twopm.transfer;

public class Customer {

	String custName;

	String mobile;

	String custAddress;

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getCustAddress() {
		return custAddress;
	}

	public void setCustAddress(String custAddress) {
		this.custAddress = custAddress;
	}

	@Override
	public String toString() {
		return "Customer [custName=" + custName + ", mobile=" + mobile
				+ ", custAddress=" + custAddress + "]";
	}
}
