require 'pry'

def consolidate_cart(cart)

  cart.each_with_object({}) do |ele, result|
    ele.each do |item, inner_hash|
      if result[item]
        inner_hash[:count] += 1
      else
        inner_hash[:count] = 1
        result[item] = inner_hash
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    disc_item = coupon[:item]
    new_key = "#{disc_item} W/COUPON"
    if cart[disc_item] && cart[disc_item][:count] >= coupon[:num]
      if cart[new_key]
        cart[new_key][:count] += 1
      else
        cart[new_key] = {:price => coupon[:cost], :clearance => cart[disc_item][:clearance], :count => 1}
      end

      cart[disc_item][:count] -= (coupon[:num])
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item, item_hash|
    if item_hash[:clearance] == true
      item_hash[:price] = (item_hash[:price] * 0.8).round(1)
    end
  end
  return cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0

  final_cart.each do |item, item_hash|
    total += (item_hash[:price] * item_hash[:count])
  end

  if total > 100
    total *= 0.9
  end

  return total
end
