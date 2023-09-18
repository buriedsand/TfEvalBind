import os
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.legend import Legend


def load_and_process_data(
    results_file,
    meta_file,
    tf_filter=None,
    cell_type_filter=None,
):
    # Load data
    results = pd.read_csv(
        results_file, header=None, names=["bed1", "bed2", "jaccard_similarity"]
    )
    meta = pd.read_csv(meta_file)

    if tf_filter:
        meta = meta[meta["TF"].isin(tf_filter)]
    if cell_type_filter:
        meta = meta[meta["Cell group"].isin(cell_type_filter)]

    # Preprocess BED file names
    for col in ["bed1", "bed2"]:
        results[col] = results[col].str.extract(r"/([^/]+)\.bed")

    if tf_filter or cell_type_filter:
        results = results[
            results["bed1"].isin(meta["ID"]) & results["bed2"].isin(meta["ID"])
        ]

    # Create symmetric matrix
    matrix = results.pivot(index="bed1", columns="bed2", values="jaccard_similarity")
    matrix = matrix.combine_first(matrix.T)
    np.fill_diagonal(matrix.values, 1)

    return matrix, meta


def prepare_metadata(matrix, meta, id_column, tf_column, cell_type_column):
    row_colors = meta.set_index(id_column).loc[
        matrix.index, [tf_column, cell_type_column]
    ]

    tf_palette = dict(
        zip(
            row_colors[tf_column].unique(),
            sns.color_palette("husl", n_colors=row_colors[tf_column].nunique()),
        )
    )
    cell_palette = dict(
        zip(
            row_colors[cell_type_column].unique(),
            sns.color_palette(
                "pastel", n_colors=row_colors[cell_type_column].nunique()
            ),
        )
    )

    row_colors[tf_column] = row_colors[tf_column].map(tf_palette)
    row_colors[cell_type_column] = row_colors[cell_type_column].map(cell_palette)

    return row_colors, tf_palette, cell_palette


def draw_clustered_heatmap(matrix, row_colors):
    heatmaps_kwargs = dict(
        cmap="Reds",
        vmin=0,
        vmax=1,
    )
    g = sns.clustermap(
        matrix,
        row_colors=row_colors,
        col_colors=row_colors,
        dendrogram_ratio=(0.1, 0.25),
        linewidths=0.75,
        cbar_kws={"label": "Jaccard Similarity"},
        **heatmaps_kwargs,
    )

    # Clear column dendrogram
    g.ax_col_dendrogram.clear()
    g.ax_col_dendrogram.get_xaxis().set_visible(False)
    g.ax_col_dendrogram.get_yaxis().set_visible(False)

    # Retrieve reordered data
    ordered_matrix = g.data2d
    mask = np.triu(np.ones_like(ordered_matrix, dtype=bool), k=1)
    ordered_matrix.where(~mask, np.nan, inplace=True)

    # Redraw the heatmap with the masked data
    g.ax_heatmap.clear()
    sns.heatmap(
        ordered_matrix,
        ax=g.ax_heatmap,
        cbar=False,
        xticklabels=0,
        yticklabels=1,
        linewidths=0.75,
        **heatmaps_kwargs,
    )

    return g


def add_legends(g, tf_palette, cell_palette, tf_column, cell_type_column):
    # TF legend
    legend_elements_tf = [
        plt.Line2D([0], [0], color=color, lw=4) for _, color in tf_palette.items()
    ]
    legend_labels_tf = [label for label, _ in tf_palette.items()]
    legend_tf = Legend(
        g.ax_col_dendrogram,
        legend_elements_tf,
        legend_labels_tf,
        loc="upper left",
        title=tf_column,
        bbox_to_anchor=(0.1, 1),
        ncol=5,
    )
    g.ax_col_dendrogram.add_artist(legend_tf)

    # Cell Type legend
    legend_elements_cell = [
        plt.Line2D([0], [0], color=color, lw=4) for _, color in cell_palette.items()
    ]
    legend_labels_cell = [label for label, _ in cell_palette.items()]
    legend_cell = Legend(
        g.ax_col_dendrogram,
        legend_elements_cell,
        legend_labels_cell,
        loc="upper left",
        title=cell_type_column,
        bbox_to_anchor=(0.1, 0.6),
        ncol=5,
    )
    g.ax_col_dendrogram.add_artist(legend_cell)


def generate_filename(tf_filter, cell_type_filter):
    tf_string = "_".join(tf_filter) if tf_filter else "all_TFs"
    cell_string = "_".join(cell_type_filter) if cell_type_filter else "all_cells"
    date_str = pd.Timestamp.now().strftime("%Y%m%d")
    filename = f"heatmap/{date_str}_{tf_string}_{cell_string}.svg"
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    return filename


def main(tf_filter=None, cell_type_filter=None):
    results_file = "outputs/05/jaccard_results.txt"
    meta_file = "outputs/05/master.csv"
    id_column = "ID"
    tf_column = "TF"
    cell_type_column = "Cell group"

    matrix, meta = load_and_process_data(
        results_file,
        meta_file,
        tf_filter,
        cell_type_filter,
    )
    row_colors, tf_palette, cell_palette = prepare_metadata(
        matrix, meta, id_column, tf_column, cell_type_column
    )
    g = draw_clustered_heatmap(matrix, row_colors)
    add_legends(g, tf_palette, cell_palette, tf_column, cell_type_column)
    # plt.show()
    filename = generate_filename(tf_filter, cell_type_filter)
    plt.savefig(filename, transparent=True, bbox_inches="tight")


if __name__ == "__main__":
    specific_tfs = []
    specific_cell_types = []
    main(specific_tfs, specific_cell_types)

    specific_tfs = ["TLE3"]
    specific_cell_types = []
    main(specific_tfs, specific_cell_types)

    specific_tfs = []
    specific_cell_types = ["Blood"]
    main(specific_tfs, specific_cell_types)
