# data_munger
<p>  Data Munger is a data processing tool. It is running on an Apache2 server which serves a CGI/Perl script. The CGI/Perl script generates HTML forms. Perl does form error handling, and JavaScript/jQuery are used to animate the web interface. The quantity of forms and the function of each form can be controlled by the user. CGI/Perl provides an interface to the server, to enable remote users to analyze data that would otherwise require local dependency configurations.  </p><p>I built this tool to provide a convenient front end for some radio telescope signal processing scripts that require obscure software libraries and long running times. This also enables my collaborators to run these tools over different data sets, rather than relying on email communications to order new plots.</p>
