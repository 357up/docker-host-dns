Name:           %{name_}
Version:        %{version_}
Release:        git%{release_}
Summary:        Automatically adds/removes containers' IP address to `/etc/hosts`
BuildRequires:  systemd-rpm-macros
License:        Apache License, Version 2.0
Group:          Admin
URL:            https://github.com/357up/docker-hosts
Source0:        %{name_}-%{version}.tar.gz
BuildArch:      noarch
Requires:       systemd, (docker-ce or podman-docker), jq

%description
A script that monitors docker start/stop events and adds/removes containers' IP address to/from /etc/hosts so that they can be automatically addressed by their hostnames.

%prep
%setup -q

%install
mkdir -p %{buildroot}/%{_sbindir}
mkdir -p %{buildroot}/%{_unitdir}
install -m 0755 %{name_} %{buildroot}/%{_sbindir}/%{name_}
install %{name_}.service %{buildroot}/%{_unitdir}/%{name_}.service

%post
/usr/bin/rpm -q podman-docker &&
    /usr/bin/sed -E -i "s/(Requires=)docker(\.socket)/\1podman\2/" %{_unitdir}/%{name_}.service
%systemd_post %{name_}.service
/bin/systemctl enable --now %{name_}.service

%preun
%systemd_preun %{name_}.service

%postun
%systemd_postun_with_restart %{name_}.service

%files
%{_sbindir}/%{name_}
%{_unitdir}/%{name_}.service