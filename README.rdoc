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
		* Critical ports
		* Critical web sites hosted
* Query the network
	* What is wrong: returns items (hosts, ports, websites) that are not functioning

== SYNOPSIS:

  FIX (code is still in development and usage isn't available)

== REQUIREMENTS:

* Ruby 1.8+
* Windows system for Windows-specific functions:
	* Windows services

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
