defmodule DemoWeb.CounterLive.Index do
    use Phoenix.LiveView
    alias DemoWeb.Router.Helpers, as: Routes

    @phones([
        %{ name: "iPhone", count: 0},
        %{ name: "One Plus", count: 0},
        %{ name: "Huwawei", count: 0},
        %{ name: "Oppo Reno", count: 0},
        %{ name: "RedMi+", count: 0},
        %{ name: "Pixel 5", count: 0},
        %{ name: "Samsung galaxy", count: 0},
        %{ name: "Motorolla", count: 0},
        %{ name: "HTC", count: 0},
        ])
    
    @items([
      %{ name: "iPhone", count: 5},
      %{ name: "One Plus", count: 4},
      %{ name: "Huwawei", count: 3},
    ])

    new_items = []
    
    def render(assigns) do
    ~L"""
        <div class="close-cart" phx-click="close-cart">
      <div class="header">
        <p class="cart" phx-click="open-cart">Cart</p>
        <h1>Phoenix Demo Cart</h1>
      </div>
      <div class="product-container">
      <div class="cart-modal-container">
      <%= if @isCartOpen do %>
          <div class="cart-modal">
            <%= if Enum.count(@items) === 0 do %>
              <p class="empty-cart">There are no items in your cart...</p> 
            <% else %>
              <%= for item <- @items do %>
              <div class="item-card">
                <p class="remove"><%= item.name %></p>
                <div class="item-button">
                  <button phx-click="dec" phx-value-name="<%= item.name %>" class="button-style">-</button>
                  <%= item.count %>
                  <button phx-click="inc" phx-value-name="<%= item.name %>" class="button-style">+</button>
                </div>
                </div>
              <% end %>
            <% end %>
          </div>
        <% end %> 
    </div>
        <h1 class="product-header">Products</h1>
      <div class="cardcontainer">
        <%= for phone <- @phones do %>
          <div class="card">
          <p class="card-heading"><%= phone.name %></p>
          <img src="https://ekameco.com/wp-content/uploads/2019/03/product-placeholder-300x300.jpg" class="image"/>
          <div class="button-group">
            <button phx-click="dec" phx-value-name="<%= phone.name %>" class="button-style">-</button>
            <button phx-click="inc" phx-value-name="<%= phone.name %>" phx-value-count="count" class="button-style">+</button>
          </div>
          </div>
        <% end %>
      </div>
      </div>
      </div>
    """
    #   DemoWeb.CounterView.render("index.html", assigns)
    end

    def mount(_params, _session, socket) do
      {:ok, assign(
          socket,
          val: 0,
          phones: @phones,
          isCartOpen: false,
          items: @items
        )}
    end

    def handle_event("close-cart", _, socket) do
      {:noreply, update(socket, :isCartOpen, &(&1 = false))}
    end

    def handle_event("open-cart", _, socket) do
      {:noreply, update(socket, :isCartOpen, &(!&1))}
    end

    def handle_event("inc", %{"name" => name}, socket) do
      present = false
      items = socket.assigns.items
      mod_items = Enum.map(items, fn(item) -> 
        if (item.name === name) do
          %{
            name: item.name,
            count: item.count + 1
          }
        else
          item
        end
      end)
      if (present) do
        items = mod_items ++ [%{ name: name, count: 1}]
        {:noreply, update(socket, :items, &(&1 = items))}
      else
        {:noreply, update(socket, :items, &(&1 = mod_items))}
      end
    end

    def handle_event("dec", %{"name" => name}, socket) do
      items = socket.assigns.items
      mod_items = Enum.map(items, fn(item) ->
        if (item.name === name) do
          %{
            name: item.name,
            count: item.count - 1
          }
        else
         item
        end
      end)
      after_remove = Enum.filter(mod_items, fn(item) ->
        item.count !== 0
      end)
      {:noreply, update(socket, :items, &(&1 = after_remove))}
    end
end