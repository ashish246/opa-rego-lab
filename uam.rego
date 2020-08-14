package anz

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
	x := get_entitlment_set_for_user_group_role(input.user, input.group, input.role)
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
	x := "To Do"
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
	x := "To Do"
}

# For the supplied User, get the set of AD Groups.
get_ad_group_set_for_user(user_in) = ad_group_set_out {
    ad_group_ids := data.user2GroupIds[user_in]
    ad_group_set_out := { ad_group |
    	some i
        	data.group2Id[ad_group] == ad_group_ids[i]
    }
}

# For the supplied AD Group, get the set of Roles.
get_role_set_for_ad_group(ad_group_in) = role_set_out {
	role_ids := data.group2RoleIds[ad_group_in]
    role_set_out := { role |
    	some i
        	data.role2Id[role] == role_ids[i]
    }
}

# For the supplied Entitlement IDs, get the set of Entitlements.
get_entitlement_set_for_ids(entitlement_ids_in) = entitlement_set_out {
    entitlement_set_out := { entitlement |
    	some i
        	data.entitlement2Id[entitlement] == entitlement_ids_in[i]
    }
}

# For supplied User, Role, and AD Group, get the Entitlements.
get_entitlment_set_for_user_group_role(user_in, ad_group_in, role_in) = entitlement_set_out {

    # Entitlements for User
    user_entitlement_id_set := {x | x := data.user2EntitlementIds[user_in]}
    
    # Entitlements for AD Group
    ad_group_roles := get_role_set_for_ad_group(ad_group_in)
    ad_group_roles_to_entitlement_id_set := { ad_group_role: ad_group_entitlement_id |
        some i
            ad_group_role := ad_group_roles[i]
            ad_group_entitlement_id := data.role2EntitlementIds[ad_group_role]
    }

    # Entitlements for Role
    role_entitlement_ids := {x | x := data.role2EntitlementIds[role_in]}
   
	#TODO Intersection of all sets
    #final_ent_id_set := user_ent_id_set & group_ent_id_set & role_ent_id_set
	#final_ent_array := [ent | final_ent_set[ent]]
    
    entitlement_set_out := {
        "type_name(user_entitlement_id_set)=": type_name(user_entitlement_id_set),
        "type_name(ad_group_entitlement_id_set)=": type_name(ad_group_roles_to_entitlement_id_set),
        "type_name(role_entitlement_ids)=": type_name(role_entitlement_ids),
        "user_entitlement_id_set=": user_entitlement_id_set,
        "ad_group_entitlement_id_set=": ad_group_roles_to_entitlement_id_set,
        "role_entitlement_ids=": role_entitlement_ids
    }
}

### BEGIN TODO ###

# For the supplied set of AD Groups, get the Roles.
#get_roles_for_ad_groups(ad_groups) = roles {
#	roles := { ad_group_roles |
#    	some i
#        	ad_group_roles = get_roles_for_ad_group(ad_groups[i])
#    }
#}
