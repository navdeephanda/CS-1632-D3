require 'sinatra'
require 'sinatra/reloader'

def table(n, true_symbol, false_symbol)
  arr = []
  (2**n).times do |row|
    a = []
    n.times { |shift| a.push("#{(row >> shift) & 1 == 0 ? false_symbol : true_symbol} ") }
    arr.push(a.join(" "))
  end
  arr
end

def and
end

# ****************************************
# GET REQUESTS START HERE
# ****************************************

# What to do if we can't find the route
not_found do
  status 404
  erb :error
end

# If a GET request comes in at /, do the following.

get '/' do
  erb :index
end

get '/display' do
  true_symbol = params['true_symbol']
  false_symbol = params['false_symbol']
  size = params['size'].to_i

  truth_table = table(size, true_symbol, false_symbol)

  erb :display, :locals => { size: size, truth_table: truth_table }
end
