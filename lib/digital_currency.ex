defmodule DigitalCurrency.Cli do
  @moduledoc """
  Documentation for DigitalCurrency.
  """
  import Money
  use Timex
  alias TableRex.Table
 
  def main(argv) do
    argv
    |> parse_args
    |> run
  end

  defp parse_args(args) do
    parsed_args = OptionParser.parse(args, aliases: [c: :currency, l: :limit], strict: [currency: :string, limit: :string])

    args = case parsed_args do
            {[currency: currency], _, _} ->
              %{currency: currency}
            {[limit: limit], _, _} ->
              %{limit: limit}
            {[currency: currency, limit: limit], _, _} ->
              %{currency: currency, limit: limit}
            {[limit: limit, currency: currency], _, _} ->
              %{limit: limit, currency: currency}
            _ -> ""
          end

    args
  end

  defp run(args) do
    CliSpinners.spin :dots7, 3000
    
    currency = case Map.has_key? args, :currency do
                  true ->
                    currency(args.currency)
                  _ ->
                    :USD
                end

    limit = case Map.has_key? args, :limit do
              true ->
                "&limit=#{args.limit}"
              _ ->
                ""
            end

    url = "https://api.coinmarketcap.com/v1/ticker/?convert=#{Atom.to_string(currency)}#{limit}"

    response = HTTPotion.get url
    {:ok, body} = handle_json(response)

    title = "Crypto Currency Standings"
    header = ["Rank", "Currency", "Price", "Change (1 hr)", "Change (24 hr)", "Change (7 days)"]
    
    price_string = "price_#{Atom.to_string(currency) |> String.downcase}"

    rows = Enum.map(body, fn(coin) -> 
            price = Money.parse!(coin["#{price_string}"], currency)
            [coin["rank"],"💵 #{coin["symbol"]}", price, "#{coin["percent_change_1h"]}%", "#{coin["percent_change_24h"]}%", "#{coin["percent_change_7d"]}%"]
          end)

    d = Timex.local

    IO.puts "\nLast checked #{d |> Timex.format!("{h12}:{m}:{s} {AM}")}"

    Table.new(rows, header)
    |> Table.put_title(title)
    |> Table.put_column_meta(3..5, color: fn(text, value) -> if String.starts_with?(value, "-"), do: [:red, text], else: [:green, text] end)
    |> Table.put_column_meta(2, color: fn(text, value) -> if String.starts_with?(value, "-"), do: [:red, text], else: [:green, text] end)
    |> Table.put_header_meta(1..5, color: :white)
    |> Table.render!(header_separator_symbol: "=", horizontal_style: :all)
    |> IO.puts
  end

  defp handle_json(%{status_code: 200, body: body}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  defp currency(cur) do
    String.to_atom cur
  end
end
