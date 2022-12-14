# -*- coding: utf-8 -*-
"""
Created on Mon Aug  1 10:36:23 2022

@author: Anis Maysami
"""

#This function to convert to superscript
def get_super(x):
	normal = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-=()"
	super_s = "ᴬᴮᶜᴰᴱᶠᴳᴴᴵᴶᴷᴸᴹᴺᴼᴾQᴿˢᵀᵁⱽᵂˣʸᶻᵃᵇᶜᵈᵉᶠᵍʰᶦʲᵏˡᵐⁿᵒᵖ۹ʳˢᵗᵘᵛʷˣʸᶻ⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁼⁽⁾"
	res = x.maketrans(''.join(normal), ''.join(super_s))
	return x.translate(res)
