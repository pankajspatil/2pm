package com.org.twopm.transfer;

public class Status {

	private Integer statusId;
	
	private String statusCode;
	
	private String statusName;
	
	private Boolean isActive;
	
	private Integer createdBy;
	
	private String createdOn;

	public Integer getStatusId() {
		return statusId;
	}

	public void setStatusId(Integer statusId) {
		this.statusId = statusId;
	}

	public String getStatusCode() {
		return statusCode;
	}

	public void setStatusCode(String statusCode) {
		this.statusCode = statusCode;
	}

	public String getStatusName() {
		return statusName;
	}

	public void setStatusName(String statusName) {
		this.statusName = statusName;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	public Integer getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(Integer createdBy) {
		this.createdBy = createdBy;
	}

	public String getCreatedOn() {
		return createdOn;
	}

	public void setCreatedOn(String createdOn) {
		this.createdOn = createdOn;
	}

	@Override
	public String toString() {
		return "Status [statusId=" + statusId + ", statusCode=" + statusCode
				+ ", statusName=" + statusName + ", isActive=" + isActive
				+ ", createdBy=" + createdBy + ", createdOn=" + createdOn + "]";
	}
}
