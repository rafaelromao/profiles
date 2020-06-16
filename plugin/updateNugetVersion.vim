function! UpdatePackageVersion(package, version)

    let l:originalRegV = @v
    let l:originalRegP = @p
    let l:originalRegSlash = @/

    let l:cr = "\<CR>"

    let l:packagePattern = substitute(a:package, '\.', '\\.', 'g')
    let l:versionDots = strlen(substitute(a:version, '[^\.]', '', 'g'))

    let @v = a:version
    let @p = l:packagePattern

    exe 'Ggrep "' . l:packagePattern . '" **/packages.config'
    exe 'silent cdo norm 02f= di""vP'

    let l:packageQF = getqflist()

    let l:packagePattern = '<HintPath>.*' . l:packagePattern

    exe 'Ggrep "' . l:packagePattern . '" **/*.csproj'
    exe 'silent cdo norm :let @/=@p' . l:cr . 'nf\' . (l:versionDots + 1) . 'T.dt\"vP'

    let l:projQF = getqflist()

    call setqflist(l:packageQF + l:projQF)

    let @v = l:originalRegV
    let @p = l:originalRegP
    let @/ = l:originalRegSlash

endfunction

command! -nargs=+ UpdatePackageVersion call UpdatePackageVersion(<f-args>)

