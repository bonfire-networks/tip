# Tip

Less than a type, just the tip.

## Status: experimental

New, probably buggy, has no tests.

## Usage

```elixir
use Tip # or require Tip; import Tip

def greet(name) do
  # Will typecheck when the Mix env is dev or test
  # Will be erased in production
  "Hello, " <> the(BitString, name)
end
```

## Installation

Full installation requires not only a dependency but also for you to
add `protocol_ex` to your project's compilers setting:

```elixir
def project do
  [
    # ...
    compilers: Mix.compilers ++ [:protocol_ex],
    # ...
  ]
end
```

## Copyright and license

Copyright (c) 2020 Tip contributors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
