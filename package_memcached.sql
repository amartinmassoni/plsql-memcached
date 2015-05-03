CREATE OR REPLACE
package memcached is
/*
	Interface to memcached servers, using text protocol
	Aurelio Martin Massoni, 2015
*/

	function open_connection(
			host	varchar2,
			port	number		default 11211
		) return binary_integer;

	function set_value( connection binary_integer, the_key varchar2, the_value varchar2, the_flags binary_integer default 0, the_exptime binary_integer default 0 ) return varchar2;

	procedure close_connection( connection binary_integer );

end;
/

