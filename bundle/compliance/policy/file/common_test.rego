package compliance.policy.file.common

import data.compliance.lib.assert

test_file_ownership_match_match {
	user := "root"
	group := "root"
	requierd_user := "root"
	requierd_group := "root"
	file_ownership_match(user, group, requierd_user, requierd_group)
}

test_file_ownership_match_user_mismatch {
	user := "owner"
	group := "root"
	requierd_user := "root"
	requierd_group := "root"
	assert.is_false(file_ownership_match(user, group, requierd_user, requierd_group))
}

test_file_ownership_match_gid_mismatch {
	user := "root"
	group := "owner"
	requierd_user := "root"
	requierd_group := "root"
	assert.is_false(file_ownership_match(user, group, requierd_user, requierd_group))
}

test_file_ownership_match_user_gid_mismatch {
	user := "owner"
	group := "owner"
	requierd_user := "root"
	requierd_group := "root"
	assert.is_false(file_ownership_match(user, group, requierd_user, requierd_group))
}

test_file_permission_match {
	users := [0, 1, 2, 3, 4, 5, 6, 7]
	groups := [0, 1, 2, 3, 4, 5, 6, 7]
	others := [0, 1, 2, 3, 4, 5, 6, 7]

	results := {file_permission_match(filemode, 7, 7, 7) | filemode := sprintf("%d%d%d", [users[u], groups[g], others[o]])}
	assert.all_true(results)
}

test_file_permission_match_octal {
	users := [0, 1, 2, 3, 4, 5, 6, 7]
	groups := [0, 1, 2, 3, 4, 5, 6, 7]
	others := [0, 1, 2, 3, 4, 5, 6, 7]

	# some file premission are in octal notation (prefix 0)
	prefix_results := {file_permission_match(filemode, 7, 7, 7) | filemode := sprintf("0%d%d%d", [users[u], groups[g], others[o]])}
	assert.all_true(prefix_results)
}

test_file_permission_match_user_mismatch {
	max_users := [0, 1, 2, 3, 4, 5, 6]

	filemode := "700"
	results := {file_permission_match(filemode, max_users[u], 7, 7)}
	assert.all_false(results)
}

test_file_permission_match_user_mismatch_octal {
	max_users := [0, 1, 2, 3, 4, 5, 6]

	# some file premission are in octal notation (prefix 0)
	octal_filemode := "0700"
	octal_results := {file_permission_match(octal_filemode, max_users[u], 7, 7)}
	assert.all_false(octal_results)
}

test_file_permission_match_group_mismatch {
	max_groups := [0, 1, 2, 3, 4, 5, 6]

	filemode := "070"
	results := {file_permission_match(filemode, 7, max_groups[g], 7)}
	assert.all_false(results)
}

test_file_permission_match_group_mismatch_octal {
	max_groups := [0, 1, 2, 3, 4, 5, 6]

	# some file premission are in octal notation (prefix 0)
	octal_filemode := "0070"
	octal_results := {file_permission_match(octal_filemode, 7, max_groups[g], 7)}
	assert.all_false(octal_results)
}

test_file_permission_match_other_mismatch {
	max_others := [0, 1, 2, 3, 4, 5, 6]

	filemode := "007"
	results := {file_permission_match(filemode, 7, 7, max_others[o])}
	assert.all_false(results)
}

test_file_permission_match_other_mismatch_octal {
	max_others := [0, 1, 2, 3, 4, 5, 6]

	# some file premission are in octal notation (prefix 0)
	octal_filemode := "0007"
	octal_results := {file_permission_match(octal_filemode, 7, 7, max_others[o])}
	assert.all_false(octal_results)
}

test_file_in_path {
	path := "/path/to/file/"
	file_path := "/path/to/file/my_file.txt"
	file_in_path(path, file_path)
}

test_file_in_path_recursive {
	path := "/path/to/file/"
	file_path := "/path/to/file/dir1/dir2/dir3/my_file.txt"
	file_in_path(path, file_path)
}

test_file_in_path_not_in_path {
	path := "/path/to/file/"
	file_path := "/path/to/dir/file/my_file.txt"
	assert.is_false(file_in_path(path, file_path))
}
