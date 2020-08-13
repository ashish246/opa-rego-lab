package anz

main = result {
# 	ad_groups := get_ad_groups_for_user(input.user)
#     result := {
#     	"ad_groups": ad_groups
#     }
    
    ents := get_ent_for_user_group_role(input.user, input.group, input.role)
    result := {
    	"ents": ents
    }
}

#GET /entitlements?
#                role=x
#                adGroups=y
#                user = z
#return:[
#entitlement {
#                roles:{
#                                adGroups:
#                }
#}             
#]
entitlements = x {
	x := ""
}

#GET /roles?
#                entitlement = x
#                LDAPgroups=y
#                user = z
#return:[
#                roles:{
#                                adGroups:[]
#                                entitlements:[
#                                ]
#                }
#]
roles = x {
	x := ""
}

# GET /adGroups?
#                role=x
#                entitlement=y
#                user = z
#return:[
#                adGroups[
#                roles:{  
#                                entitlements:[
#                                ]
#                }
#                ]
#]
ad_groups = x {
	x := ""
}

# For the supplied User, get the AD Groups via the user2GroupIds and group2Id maps.
get_ad_groups_for_user(user) = ad_groups {
    ad_group_ids := data.user2GroupIds[user]
    ad_groups := { ad_group |
    	some i
        	data.group2Id[ad_group] == ad_group_ids[i]
    }
}

# @AshishT - For supplied user, role, and group return the entitlements
get_ent_for_user_group_role(user, group, role) = ents {
	
    # Find sets of entitlements for each input
    user_ent_set := {data.user2EntitlementIds[user][_]}
    group_ent_set := {data.role2EntitlementIds[data.id2Role[data.group2RoleIds[group][_]]][_]}
    role_ent_set := {data.role2EntitlementIds[role][_]}

#     role_ent_set[ent1] {ent1:= data.role2EntitlementIds[role][_]}
#     group_ent_set[ent2] {ent2:= data.role2EntitlementIds[data.id2Role[data.group2RoleIds[group][_]]][_]}
#     user_ent_set[ent3] {ent3 := data.user2EntitlementIds[user][_]}
   
	# Find intersection of all three sets
    final_ent_set := role_ent_set & group_ent_set & user_ent_set

	#final_ent_array := [ent | final_ent_set[ent]]
    
	# Find entitlements name for ids
    ents := { ent | 
    	some i
        data.entitlement2Id[ent] == final_ent_set[i] 
      }
      
}

### BEGIN TODO ###

# For the supplied set of AD Groups, get the Roles.
get_roles_for_ad_groups(ad_groups) = roles {
	roles := { ad_group_roles |
    	some i
        	ad_group_roles = get_roles_for_ad_group(ad_groups[i])
    }
}

# For the supplied AD Group, get the Roles via the group2RoleIds and role2Id maps.
get_roles_for_ad_group(ad_group) = roles {
	role_ids := data.group2RoleIds[ad_group]
    roles := { role |
    	some i
        	data.role2Id[role] == role_ids[i]
    }
}
