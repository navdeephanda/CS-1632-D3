require 'sinatra'
require 'sinatra/reloader'

def table_and(n, bits, true_symbol, false_symbol)
  if n == 2**bits - 1
    return true_symbol
  end
  return false_symbol
end

def table_or(n, bits, true_symbol, false_symbol)
  if n == 0
    return false_symbol
  end
  return true_symbol
end

def table_nand(n, bits, true_symbol, false_symbol)
  if(table_and(n, bits, true_symbol, false_symbol) == true_symbol)
    return false_symbol
  end
  return true_symbol
end

def table_nor(n, bits, true_symbol, false_symbol)
  if(table_or(n, bits, true_symbol, false_symbol) == true_symbol)
    return false_symbol
  end
  return true_symbol
end

def gen_binary_array_representation(n, bits, true_symbol, false_symbol)
  a = []
  bits.times { |shift| a.push("#{(n >> shift) & 1 == 1 ? true_symbol : false_symbol} ") }
  a.reverse
end

def table(n, true_symbol, false_symbol)
  arr = []
  (0..2**n-1).each do |row|
    a = gen_binary_array_representation(row, n, true_symbol, false_symbol)
    a.push("#{table_and(row, n, true_symbol, false_symbol)} ")
    a.push("#{table_or(row, n, true_symbol, false_symbol)} ")
    a.push("#{table_nand(row, n, true_symbol, false_symbol)} ")
    a.push("#{table_nor(row, n, true_symbol, false_symbol)} ")
    arr.push(a)
  end
  arr
end

def valid_args?(true_symbol, false_symbol, size)
  if true_symbol.length > 1 || false_symbol.length > 1
    return false
  end
  if true_symbol == false_symbol
    return false
  end
  if size < 2
    return false
  end
  return true
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
  true_symbol = params['true_symbol'] || "T"
  false_symbol = params['false_symbol'] || "F"
  size = params['size']

  if true_symbol.strip.empty?
    true_symbol = "T"
  end
  if false_symbol.strip.empty?
    false_symbol = "F"
  end
  if size.nil?
    size = 3
  elsif size.strip.empty?
    size = 3
  end

  size = size.to_i

  if valid_args?(true_symbol, false_symbol, size)
    truth_table = table(size, true_symbol, false_symbol)
    erb :display, :locals => { size: size, truth_table: truth_table }
  else
    erb :error_invalid_params
  end
end
