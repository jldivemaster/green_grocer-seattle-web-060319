require 'pry'

def consolidate_cart(cart)
  new_cart = {}
  cart.each do |ele|
    ele.each do |k, inner_hash|
      inner_hash[:count] = 1
      if !new_cart.keys.include?(k)
        new_cart[k] = inner_hash
      elsif new_cart.keys.include?(k)
        inner_hash[:count] += 1
      end
    end
  end
  return new_cart.compact
end

def apply_coupons(cart, coupons)
  #cart.each do |thing, item_hash|

  consolidated_cart = consolidate_cart(cart)
  coupons.each do |coupon|
    disc_item = coupon[:item]
    if (consolidated_cart.keys.include?(disc_item)) && (!consolidated_cart.has_key?("#{disc_item} W/COUPON"))
      consolidated_cart[disc_item][:count] -= (coupon[:num])
      new_key = "#{disc_item} W/COUPON"
      consolidated_cart[new_key] = {:price => coupon[:cost], :clearance => consolidated_cart[disc_item][:clearance], :count => 1}
    elsif (consolidated_cart.keys.include?(disc_item)) && (consolidated_cart.has_key?("#{disc_item} W/COUPON"))
      consolidated_cart[new_key][:count] += 1
      consolidated_cart[disc_item][:count] -= (coupon[:num])
    end
  end
end
  return consolidated_cart
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
  consolidate_cart(cart)

  if coupons.length > 0
    apply_coupons(cart, coupons)
  end

  apply_clearance(cart)

  total = 0
  cart.each do |item, item_hash|
    total += (inner_hash[:price] * inner_hash[:count])
  end

  if total > 100
    total *= 0.9
  end

  return total
end
