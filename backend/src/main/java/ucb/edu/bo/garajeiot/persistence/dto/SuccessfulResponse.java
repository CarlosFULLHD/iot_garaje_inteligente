package ucb.edu.bo.garajeiot.persistence.dto;

import java.time.LocalDateTime;


public class SuccessfulResponse {
    private LocalDateTime timeStamp;
    private String status;
    private String message;
    private Object result;

    public SuccessfulResponse(String status, String message, Object result) {
        this.timeStamp = LocalDateTime.now();
        this.status = status;
        this.message = message;
        this.result = result;
    }

    public LocalDateTime getTimeStamp() {
        return timeStamp;
    }

    public void setTimeStamp(LocalDateTime timeStamp) {
        this.timeStamp = timeStamp;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getResult() {
        return result;
    }

    public void setResult(Object result) {
        this.result = result;
    }
}
