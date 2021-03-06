/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.portal.kernel.util;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Shuyang Zhou
 */
public class ListMergeable<T> implements Mergeable<ListMergeable<T>> {

	public void add(T t) {
		_list.add(t);
	}

	public boolean contains(T t) {
		return _list.contains(t);
	}

	public ListMergeable<T> merge(ListMergeable<T> listMergeable) {
		if ((listMergeable == null) || (listMergeable == this)) {
			return this;
		}

		for (T t : listMergeable._list) {
			if (!_list.contains(t)) {
				_list.add(t);
			}
		}

		return this;
	}

	public String mergeToString(String delimiter) {
		return StringUtil.merge(_list, delimiter);
	}

	private List<T> _list = new ArrayList<T>();

}