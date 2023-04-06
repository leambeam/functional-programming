defmodule Blackjack do

  # Define a struct for the game state
  defmodule State do
    defstruct deck: [], dealer_hand: [], player_hand: []
  end

  # Create a deck of cards with four suits and thirteen values
  def create_deck do
    for suit <- ['♥️', '♦️', '♠️', '♣️'],
        value <- ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'] do
      "#{value}#{suit}"
    end
  end

  # Start the game by creating a new game state and spawning a dealer process
  # Then, the dealer is sent two initial cards, and the player process is started
  def start_game do
    IO.puts "Welcome to Blackjack!"
    initial_state = %State{deck: create_deck(), dealer_hand: [], player_hand: []}
    dealer_pid = spawn_link(fn -> dealer_process(initial_state) end)
    initial_cards = [draw_card(dealer_pid), draw_card(dealer_pid)]
    player_process(dealer_pid, initial_cards)
  end

  # Prompt the player to enter their choice of whether to hit or stand, and return the choice
  def get_player_choice do
    input = IO.gets("Hit or stand? (h/s): ") |> String.trim()

    case input do
      "h" -> :h
      "s" -> :s
      _ ->
        IO.puts("Invalid choice. Please enter 'h' for hit or 's' for stand.")
        get_player_choice()
    end

  end

  # The player process, which handles player turns
  def player_process(dealer_pid, player_hand) do
    IO.puts "Your hand: #{hand_string(player_hand)}"
    # Request the dealer's hand and receive it
    send(dealer_pid, {:request_dealer_hand, self()})
    dealer_hand = receive do
      {:dealer_hand, dealer_hand} -> dealer_hand
    end
    IO.puts "Dealer's hand: #{hand_string(dealer_hand)}"

    # If the player chooses to hit, draw a new card, add it to the player's hand, and continue the game
    # Otherwise, if the player chooses to stand, send a message to the dealer process and receive the result
    # Finally, print the result and ask the player if they want to play again
    case get_player_choice() do
      :h ->
        card = draw_card(dealer_pid)
        new_hand = player_hand ++ [card]
        if bust?(new_hand) do
          IO.puts "Your hand: #{hand_string(new_hand)}"
          IO.puts "Busted! Dealer wins!"
          play_again?()
        else
          player_process(dealer_pid, new_hand)
        end
      :s ->
        send(dealer_pid, {:player_stands, self(), player_hand})
        result_score = receive do
          {:result, result_score} -> result_score
        end
        IO.puts "Result: #{result_score}"
        play_again?()
      _ ->
        IO.puts "Invalid choice. Please enter 'h' for hit or 's' for stand."
        player_process(dealer_pid, player_hand)
    end
  end

  # The dealer process, which handles dealer turns
  def dealer_process(state) do
    {new_dealer_hand, remaining_deck} =

      if state.dealer_hand == [] do
        drawn_cards = [draw_card_from_deck(state.deck), draw_card_from_deck(state.deck)]
        cards = Enum.map(drawn_cards, fn {card, _} -> card end)
        {cards, List.delete(state.deck, drawn_cards)}
      else
        {state.dealer_hand, state.deck}
      end

    new_state = %{state | dealer_hand: new_dealer_hand, deck: remaining_deck}

    receive do

      {:request_dealer_hand, player_pid} ->
        send(player_pid, {:dealer_hand, new_dealer_hand})
        dealer_process(new_state)

      {:draw_card, requester_pid} ->
        {card, remaining_deck} = draw_card_from_deck(state.deck)
        send(requester_pid, {:card_drawn, card})
        updated_state = %{state | deck: remaining_deck}
        dealer_process(updated_state)

      {:player_stands, player_pid, player_hand} ->
        dealer_score = score(new_dealer_hand)

        if dealer_score < 17 do
          {card, remaining_deck} = draw_card_from_deck(state.deck)
          updated_hand = new_dealer_hand ++ [card]
          IO.puts "Dealer's hand: #{hand_string(updated_hand)}"
          updated_state = %{state | dealer_hand: updated_hand, deck: remaining_deck}
          dealer_process(updated_state)
        else
          result_score = result(new_dealer_hand, player_hand)
          send(player_pid, {:result, result_score})
        end

    end
  end


  def result(dealer_hand, player_hand) do

    dealer_score = score(dealer_hand)
    player_score = score(player_hand)

    case dealer_score do
      _ when dealer_score > 21 -> "You win!"
      _ when player_score > dealer_score -> "You win!"
      _ -> "Dealer wins!"
    end

  end

  def hand_string(hand) do

    Enum.map(hand, fn card ->
      case card do
        {rank, suit} ->
          "#{rank}#{suit}"
        card when is_binary(card) ->
          to_string(card)
        _ ->
          "Invalid card: #{inspect(card)}"
      end
    end)
    |> Enum.join(" ")

  end

  def bust?(hand) do
    score(hand) > 21
  end

  def score(cards) do
    # Calculates the total score of the cards in the hand
    # Ace is counted as 11 if the score is below or equal to 21, and 1 otherwise
    total = Enum.reduce(cards, 0, fn(card, acc) ->
      case card do
        # The rank is the first character of the card string
        # If it's a number, add that to the score
        {rank, _} when is_binary(rank) and byte_size(rank) == 1 ->
          case String.to_integer(rank) do
            n when n in 2..10 -> acc + n
            1 -> if acc + 11 > 21, do: acc + 1, else: acc + 11
            _ -> acc + 10
          end
        _ ->
           # If the card is not in the correct format, return an error message
          "Invalid card: #{inspect(card)}"
      end
    end)
    # If the total score is an integer, return it, otherwise return an error message
    if is_integer(total) do
      total
    else
      {:error, total}
    end
  end

  def draw_card(dealer_pid) do
  # Sends a message to the dealer process to draw a card from the deck
    send(dealer_pid, {:draw_card, self()})
    # Waits for a message with the drawn card
    receive do
      {:card_drawn, card} -> card
    end
  end

  defp draw_card_from_deck(deck) do
    # Draws a random card from the deck and returns it along with the updated deck
    card = Enum.random(deck)
    {card, List.delete(deck, card)}
  end

  def play_again? do
    case IO.gets("Play again? (y/n): ") |> String.trim() do
      "y" -> start_game()
      "n" ->
      IO.puts("Thanks for playing!")
      Kernel.exit(:normal)
      _ ->
        IO.puts "Invalid choice. Please enter 'y' for yes or 'n' for no."
        play_again?()
    end
  end

end

Blackjack.start_game()
