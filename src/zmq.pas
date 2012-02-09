unit zmq;
{
	Copyright (c) 2007-2011 iMatix Corporation
	Copyright (c) 2007-2011 Other contributors as noted in the AUTHORS file

	This file is part of 0MQ.

	0MQ is free software; you can redistribute it and/or modify it under
	the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation; either version 3 of the License, or
	(at your option) any later version.

	0MQ is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

interface

const
  zmqlib = 'libzmq.dll';

type
  size_t = Cardinal;

//******************************************************************************
//  0MQ versioning support.
//******************************************************************************

//  Version macros for compile-time API version detection
//const
//  {$EXTERNALSYM ZMQ_VERSION_MAJOR}
//  ZMQ_VERSION_MAJOR                   = 2;
//  {$EXTERNALSYM ZMQ_VERSION_MINOR}
//  ZMQ_VERSION_MINOR                   = 1;
//  {$EXTERNALSYM ZMQ_VERSION_PATCH}
//  ZMQ_VERSION_PATCH                   = 11;

//{$EXTERNALSYM ZMQ_MAKE_VERSION}
//function ZMQ_MAKE_VERSION(major, minor, patch: Cardinal): Cardinal; inline;
//begin
//  Result := ((major)* 10000 + (minor)* 100 + (patch));
//end;

//#define ZMQ_VERSION ZMQ_MAKE_VERSION(ZMQ_VERSION_MAJOR, ZMQ_VERSION_MINOR, ZMQ_VERSION_PATCH)
//const
//  {$EXTERNALSYM ZMQ_VERSION}
//  ZMQ_VERSION                         = 20211;

//  Run-time API version detection
//ZMQ_EXPORT void zmq_version (int *major, int *minor, int *patch);
{$EXTERNALSYM zmq_version}
procedure zmq_version(var major, minor, patch: Integer); cdecl; external zmqlib;


//****************************************************************************
//  0MQ errors.
//****************************************************************************

//  A number random enough not to collide with different errno ranges on
//  different OSes. The assumption is that error_t is at least 32-bit type.
const
  {$EXTERNALSYM ZMQ_HAUSNUMERO}
  ZMQ_HAUSNUMERO                      = 156384712;

//  On Windows platform some of the standard POSIX errnos are not defined.
  {$EXTERNALSYM ENOTSUP}
  ENOTSUP                             = (ZMQ_HAUSNUMERO + 1);
  {$EXTERNALSYM EPROTONOSUPPORT}
  EPROTONOSUPPORT                     = (ZMQ_HAUSNUMERO + 2);
  {$EXTERNALSYM ENOBUFS}
  ENOBUFS                             = (ZMQ_HAUSNUMERO + 3);
  {$EXTERNALSYM ENETDOWN}
  ENETDOWN                            = (ZMQ_HAUSNUMERO + 4);
  {$EXTERNALSYM EADDRINUSE}
  EADDRINUSE                          = (ZMQ_HAUSNUMERO + 5);
  {$EXTERNALSYM EADDRNOTAVAIL}
  EADDRNOTAVAIL                       = (ZMQ_HAUSNUMERO + 6);
  {$EXTERNALSYM ECONNREFUSED}
  ECONNREFUSED                        = (ZMQ_HAUSNUMERO + 7);
  {$EXTERNALSYM EINPROGRESS}
  EINPROGRESS                         = (ZMQ_HAUSNUMERO + 8);
  {$EXTERNALSYM ENOTSOCK}
  ENOTSOCK                            = (ZMQ_HAUSNUMERO + 9);

//  Native 0MQ error codes.
  {$EXTERNALSYM EFSM}
  EFSM                                = (ZMQ_HAUSNUMERO + 51);
  {$EXTERNALSYM ENOCOMPATPROTO}
  ENOCOMPATPROTO                      = (ZMQ_HAUSNUMERO + 52);
  {$EXTERNALSYM ETERM}
  ETERM                               = (ZMQ_HAUSNUMERO + 53);
  {$EXTERNALSYM EMTHREAD}
  EMTHREAD                            = (ZMQ_HAUSNUMERO + 54);

//  This function retrieves the errno as it is known to 0MQ library. The goal
//  of this function is to make the code 100% portable, including where 0MQ
//  compiled with certain CRT library (on Windows) is linked to an
//  application that uses different CRT library.
//ZMQ_EXPORT int zmq_errno (void);
{$EXTERNALSYM zmq_errno}
function zmq_errno(): Integer; cdecl; external zmqlib;

//  Resolves system errors and 0MQ errors to human-readable string.
//ZMQ_EXPORT const char *zmq_strerror (int errnum);
//extern "C" __declspec(dllexport) const char *zmq_strerror (int errnum);
{$EXTERNALSYM zmq_strerror}
function zmq_strerror(errnum: Integer): PAnsiChar; cdecl; external zmqlib;

//****************************************************************************
//  0MQ message definition.
//****************************************************************************

//  Maximal size of "Very Small Message". VSMs are passed by value
//  to avoid excessive memory allocation/deallocation.
//  If VMSs larger than 255 bytes are required, type of 'vsm_size'
//  field in zmq_msg_t structure should be modified accordingly.
const
  {$EXTERNALSYM ZMQ_MAX_VSM_SIZE}
  ZMQ_MAX_VSM_SIZE                    = 30;

//  Message types. These integers may be stored in 'content' member of the
//  message instead of regular pointer to the data.
  {$EXTERNALSYM ZMQ_DELIMITER}
  ZMQ_DELIMITER                       = 31;
  {$EXTERNALSYM ZMQ_VSM}
  ZMQ_VSM                             = 32;

//  Message flags. ZMQ_MSG_SHARED is strictly speaking not a message flag
//  (it has no equivalent in the wire format), however, making  it a flag
//  allows us to pack the stucture tigher and thus improve performance.
  {$EXTERNALSYM ZMQ_MSG_MORE}
  ZMQ_MSG_MORE                        = 1;
  {$EXTERNALSYM ZMQ_MSG_SHARED}
  ZMQ_MSG_SHARED                      = 128;
  {$EXTERNALSYM ZMQ_MSG_MASK}
  ZMQ_MSG_MASK                        = 129;  { Merges all the flags }

//  A message. Note that 'content' is not a pointer to the raw data.
//  Rather it is pointer to zmq::msg_content_t structure
//  (see src/msg_content.hpp for its definition).
type
  PZmqMsgT = ^TZmqMsgT;
  {$EXTERNALSYM zmq_msg_t}
  zmq_msg_t = record
    content: Pointer;
    flags: Byte;
    vsm_size: Byte;
    vsm_data: array[0..ZMQ_MAX_VSM_SIZE - 1] of Byte;
  end;
  TZmqMsgT = zmq_msg_t;

//typedef void (zmq_free_fn) (void *data, void *hint);
type
  zmq_free_fn = procedure(data: Pointer; hint: Pointer);

//ZMQ_EXPORT int zmq_msg_init (zmq_msg_t *msg);
{$EXTERNALSYM zmq_msg_init}
function zmq_msg_init(var msg: zmq_msg_t): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_msg_init_size (zmq_msg_t *msg, size_t size);
{$EXTERNALSYM zmq_msg_init_size}
function zmq_msg_init_size(var msg: zmq_msg_t; size: size_t): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_msg_init_data (zmq_msg_t *msg, void *data,
//    size_t size, zmq_free_fn *ffn, void *hint);
{$EXTERNALSYM zmq_msg_init_data}
function zmq_msg_init_data(var msg: zmq_msg_t; data: Pointer;
  size: size_t; var ffn: zmq_free_fn; hint: Pointer): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_msg_close (zmq_msg_t *msg);
{$EXTERNALSYM zmq_msg_close}
function zmq_msg_close(var msg: zmq_msg_t): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_msg_move (zmq_msg_t *dest, zmq_msg_t *src);
{$EXTERNALSYM zmq_msg_move}
function zmq_msg_move(var dest: zmq_msg_t; var src: zmq_msg_t): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_msg_copy (zmq_msg_t *dest, zmq_msg_t *src);
{$EXTERNALSYM zmq_msg_copy}
function zmq_msg_copy(var dest: zmq_msg_t; var src: zmq_msg_t): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT void *zmq_msg_data (zmq_msg_t *msg);
//extern "C" __declspec(dllexport) void *zmq_msg_data (zmq_msg_t *msg);
{$EXTERNALSYM zmq_msg_data}
function zmq_msg_data(var msg: zmq_msg_t): Pointer; cdecl; external zmqlib;

//ZMQ_EXPORT size_t zmq_msg_size (zmq_msg_t *msg);
{$EXTERNALSYM zmq_msg_size}
function zmq_msg_size(var msg: zmq_msg_t): size_t; cdecl; external zmqlib;


//****************************************************************************
//  0MQ infrastructure (a.k.a. context) initialisation & termination.
//****************************************************************************

//ZMQ_EXPORT void *zmq_init (int io_threads);
//extern "C" __declspec(dllexport) void *zmq_init (int io_threads);
{$EXTERNALSYM zmq_init}
function zmq_init(io_threads: Integer): Pointer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_term (void *context);
//extern "C" __declspec(dllexport) int zmq_term (void *context);
{$EXTERNALSYM zmq_term}
function zmq_term(context: Pointer): Integer; cdecl; external zmqlib;

//****************************************************************************
//  0MQ socket definition.
//****************************************************************************

const
//  Socket types.
  {$EXTERNALSYM ZMQ_PAIR}
  ZMQ_PAIR                            = 0;
  {$EXTERNALSYM ZMQ_PUB}
  ZMQ_PUB                             = 1;
  {$EXTERNALSYM ZMQ_SUB}
  ZMQ_SUB                             = 2;
  {$EXTERNALSYM ZMQ_REQ}
  ZMQ_REQ                             = 3;
  {$EXTERNALSYM ZMQ_REP}
  ZMQ_REP                             = 4;
  {$EXTERNALSYM ZMQ_DEALER}
  ZMQ_DEALER                          = 5;
  {$EXTERNALSYM ZMQ_ROUTER}
  ZMQ_ROUTER                          = 6;
  {$EXTERNALSYM ZMQ_PULL}
  ZMQ_PULL                            = 7;
  {$EXTERNALSYM ZMQ_PUSH}
  ZMQ_PUSH                            = 8;
  {$EXTERNALSYM ZMQ_XPUB}
  ZMQ_XPUB                            = 9;
  {$EXTERNALSYM ZMQ_XSUB}
  ZMQ_XSUB                            = 10;
  {$EXTERNALSYM ZMQ_XREQ}
  ZMQ_XREQ                            = ZMQ_DEALER;  {  Old alias, remove in 3.x               }
  {$EXTERNALSYM ZMQ_XREP}
  ZMQ_XREP                            = ZMQ_ROUTER;  {  Old alias, remove in 3.x               }
  {$EXTERNALSYM ZMQ_UPSTREAM}
  ZMQ_UPSTREAM                        = ZMQ_PULL;  {  Old alias, remove in 3.x               }
  {$EXTERNALSYM ZMQ_DOWNSTREAM}
  ZMQ_DOWNSTREAM                      = ZMQ_PUSH;  {  Old alias, remove in 3.x               }

//  Socket options.
  {$EXTERNALSYM ZMQ_HWM}
  ZMQ_HWM                             = 1;
  {$EXTERNALSYM ZMQ_SWAP}
  ZMQ_SWAP                            = 3;
  {$EXTERNALSYM ZMQ_AFFINITY}
  ZMQ_AFFINITY                        = 4;
  {$EXTERNALSYM ZMQ_IDENTITY}
  ZMQ_IDENTITY                        = 5;
  {$EXTERNALSYM ZMQ_SUBSCRIBE}
  ZMQ_SUBSCRIBE                       = 6;
  {$EXTERNALSYM ZMQ_UNSUBSCRIBE}
  ZMQ_UNSUBSCRIBE                     = 7;
  {$EXTERNALSYM ZMQ_RATE}
  ZMQ_RATE                            = 8;
  {$EXTERNALSYM ZMQ_RECOVERY_IVL}
  ZMQ_RECOVERY_IVL                    = 9;
  {$EXTERNALSYM ZMQ_MCAST_LOOP}
  ZMQ_MCAST_LOOP                      = 10;
  {$EXTERNALSYM ZMQ_SNDBUF}
  ZMQ_SNDBUF                          = 11;
  {$EXTERNALSYM ZMQ_RCVBUF}
  ZMQ_RCVBUF                          = 12;
  {$EXTERNALSYM ZMQ_RCVMORE}
  ZMQ_RCVMORE                         = 13;
  {$EXTERNALSYM ZMQ_FD}
  ZMQ_FD                              = 14;
  {$EXTERNALSYM ZMQ_EVENTS}
  ZMQ_EVENTS                          = 15;
  {$EXTERNALSYM ZMQ_TYPE}
  ZMQ_TYPE                            = 16;
  {$EXTERNALSYM ZMQ_LINGER}
  ZMQ_LINGER                          = 17;
  {$EXTERNALSYM ZMQ_RECONNECT_IVL}
  ZMQ_RECONNECT_IVL                   = 18;
  {$EXTERNALSYM ZMQ_BACKLOG}
  ZMQ_BACKLOG                         = 19;
  {$EXTERNALSYM ZMQ_RECOVERY_IVL_MSEC}
  ZMQ_RECOVERY_IVL_MSEC               = 20;  {  opt. recovery time, reconcile in 3.x   }
  {$EXTERNALSYM ZMQ_RECONNECT_IVL_MAX}
  ZMQ_RECONNECT_IVL_MAX               = 21;

//  Send/recv options.
  {$EXTERNALSYM ZMQ_NOBLOCK}
  ZMQ_NOBLOCK                         = 1;
  {$EXTERNALSYM ZMQ_SNDMORE}
  ZMQ_SNDMORE                         = 2;

//ZMQ_EXPORT void *zmq_socket (void *context, int type);
//extern "C" __declspec(dllexport) void *zmq_socket (void *context, int type);
{$EXTERNALSYM zmq_socket}
function zmq_socket(context: Pointer; type_: Integer): Pointer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_close (void *s);
//extern "C" __declspec(dllexport) int zmq_close (void *s);
{$EXTERNALSYM zmq_close}
function zmq_close(s: Pointer): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_setsockopt (void *s, int option, const void *optval, size_t optvallen);
//extern "C" __declspec(dllexport) int zmq_setsockopt (void *s, int option, const void *optval, size_t optvallen);
{$EXTERNALSYM zmq_setsockopt}
function zmq_setsockopt(s: Pointer; option: Integer; const optval: Pointer; optvallen: size_t): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_getsockopt (void *s, int option, void *optval, size_t *optvallen);
//extern "C" __declspec(dllexport) int zmq_getsockopt (void *s, int option, void *optval, size_t *optvallen);
{$EXTERNALSYM zmq_getsockopt}
function zmq_getsockopt(s: Pointer; option: Integer; optval: Pointer; var optvallen: size_t): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_bind (void *s, const char *addr);
//extern "C" __declspec(dllexport) int zmq_bind (void *s, const char *addr);
{$EXTERNALSYM zmq_bind}
function zmq_bind(s: Pointer; const addr: PChar): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_connect (void *s, const char *addr);
//extern "C" __declspec(dllexport) int zmq_connect (void *s, const char *addr);
{$EXTERNALSYM zmq_connect}
function zmq_connect(s: Pointer; const addr: PChar): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_send (void *s, zmq_msg_t *msg, int flags);
//extern "C" __declspec(dllexport) int zmq_send (void *s, zmq_msg_t *msg, int flags);
{$EXTERNALSYM zmq_send}
function zmq_send(s: Pointer; var msg: zmq_msg_t; flags: Integer): Integer; cdecl; external zmqlib;

//ZMQ_EXPORT int zmq_recv (void *s, zmq_msg_t *msg, int flags);
//extern "C" __declspec(dllexport) int zmq_recv (void *s, zmq_msg_t *msg, int flags);
{$EXTERNALSYM zmq_recv}
function zmq_recv(s: Pointer; var msg: zmq_msg_t; flags: Integer): Integer; cdecl; external zmqlib;

//****************************************************************************
//  I/O multiplexing.
//****************************************************************************

const
  {$EXTERNALSYM ZMQ_POLLIN}
  ZMQ_POLLIN                          = 1;
  {$EXTERNALSYM ZMQ_POLLOUT}
  ZMQ_POLLOUT                         = 2;
  {$EXTERNALSYM ZMQ_POLLERR}
  ZMQ_POLLERR                         = 4;

type
  PZmqPollitemT = ^TZmqPollitemT;
  {$EXTERNALSYM zmq_pollitem_t}
  zmq_pollitem_t = record
    socket: Pointer;
    fd: Integer;
    events: Smallint;
    revents: Smallint;
  end;
  TZmqPollitemT = zmq_pollitem_t;

//ZMQ_EXPORT int zmq_poll (zmq_pollitem_t *items, int nitems, long timeout);
{$EXTERNALSYM zmq_poll}
function zmq_poll(var items: zmq_pollitem_t; nitems: Integer; timeout: Longint): Integer; cdecl; external zmqlib;


//****************************************************************************
//  Built-in devices
//****************************************************************************

const
  {$EXTERNALSYM ZMQ_STREAMER}
  ZMQ_STREAMER                        = 1;
  {$EXTERNALSYM ZMQ_FORWARDER}
  ZMQ_FORWARDER                       = 2;
  {$EXTERNALSYM ZMQ_QUEUE}
  ZMQ_QUEUE                           = 3;

//ZMQ_EXPORT int zmq_device (int device, void * insocket, void* outsocket);
{$EXTERNALSYM zmq_device}
function zmq_device(device: Integer; insocket: Pointer; outsocket: Pointer): Integer; cdecl; external zmqlib;

implementation

end.
