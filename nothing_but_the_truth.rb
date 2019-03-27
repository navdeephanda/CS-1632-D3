require 'sinatra'
require 'sinatra/reloader'

def gen_binary_array_representation(n, bits, true_symbol, false_symbol)
  a = []
  bits.times { |shift| a.push("#{(n >> shift) & 1 == 0 ? true_symbol : false_symbol} ") }
  a.reverse
end

def table(n, true_symbol, false_symbol)
  arr = []
  (2**n).times do |row|
    a = gen_binary_array_representation(row, n, true_symbol, false_symbol)
    arr.push(a)
  end
  arr.reverse
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
