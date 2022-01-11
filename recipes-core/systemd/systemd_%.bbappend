pkg_postinst:${PN}:libc-glibc () {
    sed -e '/^hosts:/s/\s*\<myhostname resolve\>//' \
        -e 's/\(^hosts:.*\)\(\<files\>\)\(.*\)\(\<dns\>\)\(.*\)/\1\2 myhostname resolve \3\4\5/' \
        -i $D${sysconfdir}/nsswitch.conf
}

pkg_prerm:${PN}:libc-glibc () {
    sed -e '/^hosts:/s/\s*\<myhostname resolve\>//' \
        -e '/^hosts:/s/\s*myhostname resolve//' \
        -i $D${sysconfdir}/nsswitch.conf
}
