# Authenticating Users

![](https://media.giphy.com/media/HVr4gFHYIqeti/giphy.gif)

## Learning Objectives
- Auth depedencies
- Using new changesets
- Plugs


### Auth dependencies

```
defp deps do
  [
    ...,
    {:comeonin, "~> 4.1"},
    {:bcrypt_elixir, "~> 1.0"},
  ]
end
```
Some core methods we're going to use from these new dependencies

`Comeonin.Bcrypt.hashpwsalt/1` - change entered password into hashed password
`Comeonin.Bcrypt.checkpw/2` - check some entered value vs the stored hash value
`Comeonin.Bcrypt.dummy_checkpw/0 - simulates password check with variable timing


 ### Changesets

 Recall from the last chapter we created a changeset for the user
 ```
  def changeset(user, attrs) do user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
  end
```

In this chapter, we learned to create the associated credential schema and a new `registration_changeset` to handle the association as well as our user
```
def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
  end

```

What about a custom changeset

```
  def validate_strength(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, value ->
      case Regex.match?(~r/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/, value) do
        true -> []
        false -> [{field, options[:message] || "Must be at least 8 characters long and include a number"}]
      end
    end)
  end
```

Challenge 1: These changeset checks are too simple.
2. Create a changeset validation to ensure that the password and password confirmation match |Bonus|

Hints:
- [javascript - Regex for password must contain at least eight characters, at least one number and both lower and uppercase letters and special characters - Stack Overflow](https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a)
- [Writing Custom Validations for Ecto Changesets – QuantLayer – Medium](https://medium.com/@QuantLayer/writing-custom-validations-for-ecto-changesets-4971881c7684)

## Plugs
Summary
- Two kinds of plugs: module plugs and function plugs
- Function plug is a single funciton while a module plug is a module that provides two functions with some configuration details
- Plugs have two methods: init and call
- A plug transforms a connection and most of the work happens in the call method.
- `call` happens at rutime `init` happens at compile time
- Plug uses the result of the init method as the second argument of call
- Init is a good place to validate options since it happens at compile time. Call should do as little work as possible
- `conn.assigns` allows it to be accessed by every other controller and view
- Any plug used after our plug (downstream plugs) can use the information gained from our plug
- Like endpoints and routers, controllers also have their own plug pipelin
- `halt` prevents any downstream transformations of the connection however plug pipelines explicitly check for halted: true between every plug invocation, so the halting concern is neatly solved by Plug.
- `configure_session(renew: true)` tells Plug to send the session cookie back to the client with a different identifier, in case an attacker knew, by any chance, the previous one

Discussion:
What kind of plugs can we think about writing. What sort of things could we do here

```
Request fields
These fields contain request information:

host - the requested host as a binary, example: "www.example.com"
method - the request method as a binary, example: "GET"
path_info - the path split into segments, example: ["hello", "world"]
script_name - the initial portion of the URL’s path that corresponds to the application routing, as segments, example: [“sub”,”app”]
request_path - the requested path, example: /trailing/and//double//slashes/
port - the requested port as an integer, example: 80
remote_ip - the IP of the client, example: {151, 236, 219, 228}. This field is meant to be overwritten by plugs that understand e.g. the X-Forwarded-For header or HAProxy’s PROXY protocol. It defaults to peer’s IP
req_headers - the request headers as a list, example: [{"content-type", "text/plain"}]. Note all headers will be downcased
scheme - the request scheme as an atom, example: :http
query_string - the request query string as a binary, example: "foo=bar"
```

What kinds of things could we do with plugs?

Check for mobile maybe? 

```
defmodule MoviepassWeb.Mobile do
  import Plug.Conn
  require IEx


  def init(opts), do: opts

  def call(conn, _opts) do
    headers = conn.req_headers
    case Regex.match?(~r/Mobile|iP(hone|od|ad)|Android|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|Zune/i, headers) do
      true -> assign(conn, :mobile, :true)
      false -> assign(conn, :mobile, :false)
    end
    conn
  end

end
```

Challenge 2
- We already have oauth setup in the application but we need some way to persist the user's access token. We should be thinking about how we can store that information in the session using a plug or whatever you like. In addition, what about persisting that oauth integration like we do in Learn.
