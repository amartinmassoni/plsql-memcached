CREATE OR REPLACE
package body memcached is

	type t_connection is record (
		host		varchar2( 256 ),
		port		number( 5 ),
		tcp_conn	utl_tcp.connection
	);
	type t_connection_list is table of t_connection index by binary_integer;
	the_connection_list t_connection_list;

	function open_connection( host varchar2, port number default 11211 ) return binary_integer is
		the_connection t_connection;
		connection_id binary_integer;
	begin
		connection_id := the_connection_list.count + 1;
		the_connection := null;
		the_connection.host := host;
		the_connection.port := port;
		the_connection.tcp_conn := utl_tcp.open_connection( host, port );
		the_connection_list( connection_id ) := the_connection;
		return connection_id;
	end;

	function set_value( connection binary_integer, the_key varchar2, the_value varchar2, the_flags binary_integer default 0, the_exptime binary_integer default 0 ) return varchar2 is
		the_connection t_connection;
		l_result  pls_integer;
	begin
		the_connection := the_connection_list( connection );
		l_result := utl_tcp.write_line( the_connection.tcp_conn, 'set ' || the_key || ' ' || nvl( the_flags, 0 ) || ' ' || nvl( the_exptime, 0 ) || ' ' || nvl( length( the_value ), 0 ) );
		l_result := utl_tcp.write_line( the_connection.tcp_conn, the_value );
		utl_tcp.flush( the_connection.tcp_conn );
		return utl_tcp.get_line( the_connection.tcp_conn, true );
	end;

	procedure close_connection( connection binary_integer ) is
		the_connection t_connection;
	begin
		the_connection := the_connection_list( connection );
		utl_tcp.close_connection( the_connection.tcp_conn );
		the_connection_list( connection ) := null;
	end;

begin
	the_connection_list.delete;
end;
/

