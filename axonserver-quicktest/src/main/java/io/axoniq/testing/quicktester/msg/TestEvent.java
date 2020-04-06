package io.axoniq.testing.quicktester.msg;

public class TestEvent {
    private String msg;

    public TestEvent() {
    }

    public TestEvent(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
