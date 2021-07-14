:local nama $user;
:local ip $address;
:local mac $"mac-address";
:local tanggal [/system clock get date];
:local useraktif [/ip hotspot active print count-only];
:local lby [/ip hotspot active get [find user="$nama"] login-by];
:local host [/ip dhcp-server lease get [find address="$ip"] host-name];
:local waktu [/system clock get time];

:if ([/ip hotspot user get [find name=$nama] comment]="baru") do={
    /ip hotspot user set [find name=$nama] comment="Login : $tanggal";
    /ip hotspot user set $nama mac=$mac;
    :log warning "User $nama berhasil login dan binding dengan mac : $mac" ;
    #/tool fetch url="https://api.telegram.org/botAPYBOT/sendMessage?chat_id=CHAT_ID&text= ------- Informasi Login ------- %0AVoucher : $nama%0AIP : $ip %0AMac : $mac%0AHost : $host%0Alogin-by : $lby%0ATerhubung : $useraktif user" keep-result=no;

} else= {
    :log warning "User $nama berhasil melakukan login ulang." ;
}

:if ([/system schedule find name=$nama]="") do={
    /system schedule add name=$nama interval=00:05:00 on-event="/ip hotspot active remove [find user=$nama]\r\n/ip hotspot user remove [find name=$nama]\r\n/system schedule remove [find name=$nama]" start-date=$tanggal start-time=$waktu;
}