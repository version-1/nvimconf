local prompts = {
  SayHello = 'Hello',
  CodeReadabilityAnalysis = [[
    You must identify any readability issues in the code snippet.
    Some readability issues to consider:
    - Unclear naming
    - Unclear purpose
    - Redundant or obvious comments
    - Lack of comments
    - Long or complex one liners
    - Too much nesting
    - Long variable names
    - Inconsistent naming and code style.
    - Code repetition
    You may identify additional problems. The user submits a small section of code from a larger file.
    Only list lines with readability issues, in the format <line_num>|<issue and proposed solution>
    If there's no issues with code respond with only: <OK>
  ]],
  OptimizeCode = 'Optimize the following code',
  FixBugs = 'Fix the bugs inside the following codes if any',
  AddTests = [[
    Implement tests.
    Some tests to consider:
      - Don't test private methods
      - Test edge cases
      - Test for exceptions
      - Do black box testing
      - Minimize the use of mocks and stubs from third party libraries
  ]]
}

for command, question in pairs(prompts) do
  vim.api.nvim_create_user_command(
    'Avante' .. command,
    function()
      require('avante.api').ask { question = question }
    end,
    { nargs = 0 }
  )
end

vim.api.nvim_create_user_command(
  'AvanteShowProvider',
  function()
    print(require('avante.config').provider)
  end,
  { nargs = 0 }
)

