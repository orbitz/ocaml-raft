module type LOG = sig
  type elt
  type t

  val append : elt -> t -> t option
end

module type SERVER = sig
  type t

  val equal : t -> t -> bool
end

module Make : functor (Server : SERVER) -> functor (Log : LOG) -> sig
  type 'a t

  val create            : Server.t list -> [ `Follower ] t

  val servers           : 'a t -> Server.t list
  val set_servers       : Server.t list -> 'a t -> 'a t

  val current_term      : 'a t -> int
  val voted_for         : 'a t -> Server.t option

  val log               : 'a t -> Log.t

  val leader            : 'a t -> Server.t option

  val next_index        : [ `Leader ] t -> (Server.t * int) list
  val match_index       : [ `Leader ] t -> (Server.t * int) list

  val heartbeat_timeout : [ `Follower] t -> [ `Candidate ] t

  val election_timeout  : [ `Candidate ] t -> [ `Candidate ] t
  val receive_vote      : [ `Candidate ] t -> [ `Candidate ] t
  val is_now_leader     : [ `Candidate ] t -> [ `Leader ] t option

  val append            : Log.t -> 'a t -> 'a t

end
