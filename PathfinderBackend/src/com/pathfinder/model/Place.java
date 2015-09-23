package com.pathfinder.model;

import java.util.List;

import lombok.Data;

@Data
public class Place {
	private String name;
	private String description;
	private int averageRatingOverHundred;
	private int numberOfVisits;
	private List<PlaceTag> tags;
}
