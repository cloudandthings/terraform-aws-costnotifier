def adaptive_card_payload(summary, service_costs, total_cost_block):
    """
    Create an adaptive card payload for Microsoft Teams.

    Args:
        summary (str): The summary of the adaptive card.
        total_cost_block (dict): The total cost block to include in the adaptive card.

    Returns:
        dict: A dictionary representing the adaptive card.
    """
    return {
        "type": "AdaptiveCard",
        "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
        "version": "1.4",
        "msteams": {"width": "Full"},
        "body": [
            {
                "type": "TextBlock",
                "text": summary,
                "wrap": True,
                "size": "Medium",
                # "color": "Good"
            },
            {
                "type": "Container",
                "style": "emphasis",
                "bleed": True,
                "items": [
                    {
                        "type": "ColumnSet",
                        "columns": [
                            {
                                "type": "Column",
                                "width": "50",
                                "items": [
                                    {
                                        "type": "TextBlock",
                                        "text": "**Service**",
                                        "wrap": True,
                                    }
                                ],
                            },
                            {
                                "type": "Column",
                                "width": "20",
                                "items": [
                                    {
                                        "type": "TextBlock",
                                        "text": "**$Yday**",
                                        "horizontalAlignment": "Right",
                                    }
                                ],
                            },
                            {
                                "type": "Column",
                                "width": "15",
                                "items": [
                                    {
                                        "type": "TextBlock",
                                        "text": "**Δ%**",
                                        "horizontalAlignment": "Right",
                                    }
                                ],
                            },
                            {
                                "type": "Column",
                                "width": "15",
                                "items": [
                                    {
                                        "type": "TextBlock",
                                        "text": "**Last 7d**",
                                        "horizontalAlignment": "Center",
                                    }
                                ],
                            },
                        ],
                    }
                ],
            },
            {"type": "Container", "spacing": "Small", "items": service_costs},
            total_cost_block,
        ],
    }


def add_total_to_card(total_cost, total_delta, total_sparkline):
    """
    Add total cost information to the message card.
    :param total_cost: The total cost.
    :param total_delta: The total delta percentage.
    :param total_sparkline: The sparkline for the total cost.
    :return: dict
    """

    return {
        "type": "ColumnSet",
        "spacing": "Medium",
        "separator": True,
        "columns": [
            {
                "type": "Column",
                "width": "50",
                "items": [
                    {
                        "type": "TextBlock",
                        "text": "**Total**",
                        "wrap": True,
                    }
                ],
            },
            {
                "type": "Column",
                "width": "20",
                "items": [
                    {
                        "type": "TextBlock",
                        "text": total_cost,
                        "horizontalAlignment": "Right",
                    }
                ],
            },
            {
                "type": "Column",
                "width": "15",
                "items": [
                    {
                        "type": "TextBlock",
                        "text": total_delta,
                        "horizontalAlignment": "Right",
                    }
                ],
            },
            {
                "type": "Column",
                "width": "15",
                "items": [
                    {
                        "type": "TextBlock",
                        "text": total_sparkline,
                        "horizontalAlignment": "Center",
                    }
                ],
            },
        ],
    }


def add_items_to_card(items, service_name, cost, delta, sparkline):
    """
    Add items to the message card.
    :param items: The items to be added to the message card.
    :param service_name: The name of the service.
    :param costs: The costs associated with the service.
    :return: None
    """

    items.append(
        {
            "type": "ColumnSet",
            "spacing": "Small",
            "columns": [
                {
                    "type": "Column",
                    "width": "50",
                    "items": [
                        {
                            "type": "TextBlock",
                            "text": service_name,
                            "wrap": True,
                            "size": "Small",
                        }
                    ],
                },
                {
                    "type": "Column",
                    "width": "20",
                    "items": [
                        {
                            "type": "TextBlock",
                            "text": cost,
                            "horizontalAlignment": "Right",
                            "size": "Small",
                        }
                    ],
                },
                {
                    "type": "Column",
                    "width": "15",
                    "items": [
                        {
                            "type": "TextBlock",
                            "text": delta,
                            "horizontalAlignment": "Right",
                            "size": "Small",
                        }
                    ],
                },
                {
                    "type": "Column",
                    "width": "15",
                    "items": [
                        {
                            "type": "TextBlock",
                            "text": sparkline,
                            "horizontalAlignment": "Center",
                            "size": "Small",
                        }
                    ],
                },
            ],
        }
    )
