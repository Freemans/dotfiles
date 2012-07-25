#!/bin/bash

__path_ps1() { 
   # remplacement de la $HOME par ~
   p=$(pwd)
   p=${p/$HOME/\~}

   # is that a git repo
   git_repo=$(git config --get svn-remote.svn.url) 
   # si le repo git est sur svn01, on a un repo hebex, donc on traite le path
   [[ -n $git_repo ]] && [[ -z "${git_repo/*svn01*/}" ]] \
      && git_repo=true \
      || git_repo=false
   # is that an svn repo
   svn_repo=false
   # si c'est un repo svn, bah... on va traiter le path
   [[ -d '.svn' ]] && svn_repo=true
   
   # si on est dans un repository
   if [[ $git_repo  == "true" || $svn_repo == "true" ]] ; then
  
      # on recherche le nom de produit checkouté
      cf=${p/*\/cf/cf}
      cf=${cf/\/*/}
      # et le nom de la pfs
      pfs=${p/*\/pfs_/pfs_}
      pfs=${pfs/\/*/}

      # si on a trouvé le produit, la pfs et qu'on est dans la configuration
      if [[ -n "$cf" ]] && [[ -z "${p/*configurations*/}" ]] && [[ -z "${pfs/pfs*/}" ]]; then
         p=${p/*$pfs/}
         p=${p#/}
         printf "[%s - %s] %s" "$cf" "$pfs" "$p"
      # si on a pas trouvé la pfs ou qu'on est pas dans la configuration
      elif ( [[ -n "$cf" ]] && [[ -n "${pfs/pfs*/}" ]] ) \
         || ( [[ -n "$cf" ]] && [[ -n "${p/*configurations*/}" ]] ) ; then
         p=${p/*$cf/}
         p=${p#/}
         printf "[%s] %s" "$cf" "$p"
      # sinon
      else
         printf "%s" "$p";
      fi
   else
      printf "%s" "$p";
   fi
}
