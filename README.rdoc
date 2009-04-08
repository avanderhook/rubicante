= rubicante

* RubyForge http://rubicante.rubyforge.org
* GitHub http://github.com/avanderhook/rubicante

== DESCRIPTION:

Rubicante is a business natural language (BNL) for System Administrators (SAs).
It allows SAs to define their networks in terms of servers, what those servers
provide (websites, Win32 services), and what ports they listen on.  Once the
network is defined, SAs can type in natural language questions about the network
and receive answers.

== FEATURES/PROBLEMS:

* Describe a network of computer systems
  * Hosts
    * Ports it should be listening on
    * Critical web sites hosted
* Query the network
  * What is wrong: returns items (hosts, websites) that are not functioning

== SYNOPSIS:

There are several ways that you can run Rubicante:
* An interactive shell
* An interactive shell with source file
* Cron mode
* All of the above in DEBUG mode

=== Interactive Shell:

Interactive shell mode allows you to specify hosts and run Rubicante queries against them.

  $ rubicante
  rubicante> Host webserver provides website www.my-intranet.com
  rubicante> Host webserver provides website www.good-website.com, website www.bad-website.com
  rubicante> What is wrong?
  [webserver] is returning code 500 for website www.bad-website.com

=== Interactive Shell with Source File

Interactive shell mode with files allows you to define your network's resources
in a file, load them in to rubicante, and obtain the interactive shell prompt
so you can use Rubicante queries to examine the network.

  $ cat 'my-network.bnl'
  Host webserver listens on port 80, provides website www.example.com
  Host shellserver listens on port 22
  $ rubicante -r my-network.bnl
  rubicante> What is wrong?
  [shellserver] port 22 is closed.

=== Cron Mode

Cron mode reads in the specified file and then asks Rubicante
"what is wrong?".  Any problems discovered will be logged to STDOUT
(making this ideal for calling periodically with cron), and then exiting.

  $ cat 'my-network.bnl'
  host web1 website www.mycompany.com
  host web2 website intranet.mycompany.com
  host web3 website wiki.mycompnay.com
  $ rubicante -c my-network.bnl
  [web2] is returning code 500 for website intranet.mycompany.com
  $

=== DEBUG mode

Use the '-d' flag when executing Rubicante to obtain debug output.

== BASIC LANGUAGE SPECIFICATION:

=== Conventions used
* <parameter> is a required parameter
* [optional] is an optional word (i.e., a "bubble" word for readability)

=== HOST language

* Host <hostname> [provides] website <fqdn>
  * Defines host <hostname> (if not previously defined) and registers the website a <fqdn> with it
  * Example:
	host www provides website www.example.com
* Host <hostname> [listens] [on] port <port #>
  * Defined host <hostname> (if not previously defined) and registers the port <port #> to it
  * Example:
	host www listens on port 80"
* COMBINE HOST SUBCOMMANDS IN ONE LINE
  * Example:
	host www listens on port 80, port 443, provides website www.mycompany.com, website intranet.mycompany.com

=== WHAT language

* What [is] wrong[?]
  * checks all defined hosts for problems and reports them

== REQUIREMENTS:

* Ruby 1.8+
* logging (>= 0.9.7)
* trollop (>= 1.13)

== INSTALL:

* sudo gem install rubicante

== LICENSE:

Copyright (c) 2009, Adam VanderHook
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of the Rubicante nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
