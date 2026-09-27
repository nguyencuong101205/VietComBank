package com.bank.admin.security;

import com.bank.admin.user.User;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.stream.Collectors;

/**
 * Đối tượng người dùng đã xác thực trong Spring Security context.
 * Authorities = permission codes (VD: SYS_MANAGE_USERS).
 */
@Getter
public class UserPrincipal implements UserDetails {

    private final Long id;
    private final String username;
    private final String fullName;
    private final String passwordHash;
    private final boolean active;
    private final Collection<? extends GrantedAuthority> authorities;

    public UserPrincipal(User user) {
        this.id = user.getId();
        this.username = user.getUsername();
        this.fullName = user.getFullName();
        this.passwordHash = user.getPasswordHash();
        this.active = user.isActive();
        java.util.Set<GrantedAuthority> auths = new java.util.HashSet<>();
        if (user.getRoles() != null) {
            user.getRoles().forEach(r -> {
                String roleCode = r.getCode();
                if (roleCode != null) {
                    auths.add(new SimpleGrantedAuthority(roleCode.startsWith("ROLE_") ? roleCode : "ROLE_" + roleCode));
                }
                if (r.getPermissions() != null) {
                    r.getPermissions().forEach(p -> {
                        if (p.getCode() != null) {
                            auths.add(new SimpleGrantedAuthority(p.getCode()));
                        }
                    });
                }
            });
        }
        this.authorities = java.util.Collections.unmodifiableSet(auths);
    }

    public String getAuthoritiesString() {
        return authorities.stream()
            .map(GrantedAuthority::getAuthority)
            .collect(Collectors.joining(","));
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return passwordHash;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return active;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return active;
    }
}
