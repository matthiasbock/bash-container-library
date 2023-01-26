

#
# Within the specified container create a user with the specified name
#
# Usage: container_create_user my_container username [optional: group1 group2 ...]
#
# @return 0  upon success
# @return 1  upon errors
#
function container_create_user()
{
  local container_name="$1"
  local user="$2"
  local groups="${@:3}"

  shell="/bin/bash"
  home="/home/$user"

  # Check if the user already exists
  uid=$(container_exec $container_name id $user | fgrep uid)
  if [ "$uid" != "" ]; then
    echo "Creating user $user: Already exists. Skipping."
  else
    echo -n "Creating user $user with home at $home ... "
    container_exec $container_name mkdir -p $home || return 1
    container_exec $container_name useradd -d $home -s $shell $user || return 1
    container_exec $container_name chown -R $user.$user $home || return 1
    echo "ok."
  fi

  # Adding user to groups
  if [ "$groups" != "" ]; then
    # Make sure the requested groups exist
    container_create_groups $container_name $groups

    # Add user to one group after another
    for group in $groups; do
      echo -n "Adding $user to group $group ... "
      container_exec $container_name usermod -aG $group $user
      echo "ok."
    done
    echo "Done."
  fi

  return 0
}


#
# Within the specified container create the specified groups
#
# Usage: container_create_groups my_container group1 group2 ...
#
# @return 0  upon success
# @return 1  upon errors
#
function container_create_groups()
{
  local container_name="$1"
  local groups="${@:2}"

  # For each group argument:
  for group in $groups; do
    # Check if group exists...
    gid=$(container_exec $container_name getent group $group)
    if [ "$gid" != "" ]; then
      echo "Group exists: $group"
    else
      # ...otherwise create it:
      echo -n "Creating group $group ... "
      container_exec $container_name groupadd -f $group || return 1
      echo "ok."
    fi
  done
  return 0
}
