package com.org.twopm.transfer;

public class DeliveryTracker {

	private Integer deliveryTrackerId;
	
	private User delieveryPerson;
	
	private Status deliveryStatus;
	
	private String createdOn;
	
	private Integer createdBy;
	
	private Boolean isActive;

	public Integer getDeliveryTrackerId() {
		return deliveryTrackerId;
	}

	public void setDeliveryTrackerId(Integer deliveryTrackerId) {
		this.deliveryTrackerId = deliveryTrackerId;
	}

	public User getDelieveryPerson() {
		return delieveryPerson;
	}

	public void setDelieveryPerson(User delieveryPerson) {
		this.delieveryPerson = delieveryPerson;
	}

	public Status getDeliveryStatus() {
		return deliveryStatus;
	}

	public void setDeliveryStatus(Status deliveryStatus) {
		this.deliveryStatus = deliveryStatus;
	}

	public String getCreatedOn() {
		return createdOn;
	}

	public void setCreatedOn(String createdOn) {
		this.createdOn = createdOn;
	}

	public Integer getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(Integer createdBy) {
		this.createdBy = createdBy;
	}

	public Boolean getIsActive() {
		return isActive;
	}

	public void setIsActive(Boolean isActive) {
		this.isActive = isActive;
	}

	@Override
	public String toString() {
		return "DeliveryTracker [deliveryTrackerId=" + deliveryTrackerId
				+ ", delievryPerson=" + delieveryPerson + ", deliveryStatus="
				+ deliveryStatus + ", createdOn=" + createdOn + ", createdBy="
				+ createdBy + ", isActive=" + isActive + "]";
	}
}
