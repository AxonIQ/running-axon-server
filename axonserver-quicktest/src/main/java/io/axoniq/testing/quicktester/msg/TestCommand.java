package io.axoniq.testing.quicktester.msg;

public class TestCommand {

    private String src;
    private String msg;

    public TestCommand() {
    }

    public TestCommand(String src, String msg) {
        this.src = src;
        this.msg = msg;
    }

    public String getSrc() {
        return src;
    }

    public void setSrc(String src) {
        this.src = src;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
