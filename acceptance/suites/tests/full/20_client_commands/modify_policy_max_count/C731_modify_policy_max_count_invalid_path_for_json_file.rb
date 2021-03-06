# -*- encoding: utf-8 -*-
# this is required because of the use of eval interacting badly with require_relative
require 'razor/acceptance/utils'
confine :except, :roles => %w{master dashboard database frictionless}
require 'tmpdir'

test_name "Modify policy max count with Invalid path for JSON File"
step "https://testrail.ops.puppetlabs.net/index.php?/cases/view/731"

file = '/tmp/' + Dir::Tmpname.make_tmpname(['modify-policy-max-count-', '.json'], nil)

step 'Ensure the temporary file is absolutely not present'
on agents, "rm -f #{file}"

reset_database
razor agents, 'modify-policy-max-count', %W{--json #{file}}, exit: 1 do |agent, text|
  assert_match %r{Error: File /tmp/modify-policy-max-count.*\.json not found}, text
end

