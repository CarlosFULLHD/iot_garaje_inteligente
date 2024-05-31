package bo.edu.ucb.smartpark.Smart.Park.UCB.dto;

import java.time.LocalDateTime;

public class UnsuccessfulResponse {
    private LocalDateTime timeStamp;
    private String status;
    private String error;
    private String path;

    public UnsuccessfulResponse(String status, String error, String path) {
        this.timeStamp = LocalDateTime.now();
        this.status = status;
        this.error = error;
        this.path = path;
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

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }
}
