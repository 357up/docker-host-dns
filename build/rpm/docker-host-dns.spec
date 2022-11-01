Name:           %{name_}
Version:        %{version_}
Release:        git%{release_}
Summary:        Triggered by Docker's start/die events, updates `/etc/hosts`
BuildRequires:  systemd-rpm-macros
License:        Apache License, Version 2.0
Group:          Admin
URL:            https://github.com/357up/docker-hosts
Source0:        %{name_}-%{version}.tar.gz
BuildArch:      noarch
Requires:       systemd, docker-ce, jq

%description
A script that monitors docker start/die events and adds/removes containers' IP addresses to/from /etc/hosts so that they can be automatically adressed by their hostnames.

%prep
%setup -q

%install
mkdir -p %{buildroot}/%{_sbindir}
mkdir -p %{buildroot}/%{_unitdir}
install -m 0755 %{name_} %{buildroot}/%{_sbindir}/%{name_}
install %{name_}.service %{buildroot}/%{_unitdir}/%{name_}.service

%post
%systemd_post %{name_}.service
/bin/systemctl enable --now %{name_}.service

%preun
%systemd_preun %{name_}.service

%postun
%systemd_postun_with_restart %{name_}.service

%files
%{_sbindir}/%{name_}
%{_unitdir}/%{name_}.service